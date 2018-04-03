require 'playwright/cli/utils/ask'
require 'playwright/cli/utils/display'
require 'playwright/cli/utils/os'
require 'playwright/cli/configuration'
require 'playwright/cli/template'

module Playwright
  class CLI < Hanami::CLI
    module Utils
      module FileManager

        def file_manager
          @file_manager ||= FileManager.new
        end

        class FileManager
          include Display
          include Ask
          include OS

          attr_reader :script_name, :type

          GITIGNORE = []

          def initialize script_name: nil, type: nil
            @script_name = script_name
            @type = type
          end

          def install_script script_name:, type:
            @script_name = script_name
            @type = type
            create_script_files
            set_permissions
            write_template
            create_symlink
            create_gitignore
            create_readme
            git_init
            open_editor
          end

          def uninstall_script script_name
            @script_name = script_name
            delete_script_files
          end

          def open_editor script_name: nil
            @script_name ||= script_name
            os.open_editor name: @script_name, path: root_dir
          end

          def script_name_rb
            "#{script_name}.rb"
          end

          def list_scripts
            Dir.new(self.class.plays_dir).select do |file_or_dir|
              Dir.exists?(self.class.plays_dir.join(file_or_dir)) &&
                !['..', '.'].include?(file_or_dir)
            end
          end

          private

          def self.playwright_parent_dir
            Pathname.new(Playwright::CLI.configuration.home_dir)
          end

          def self.executable_path_dir
            Pathname.new(Playwright::CLI.configuration.executable_path_dir)
          end

          def self.dot_playwright_dir
            playwright_parent_dir.join '.playwright'
          end

          def self.plays_dir
            dot_playwright_dir.join 'plays'
          end

          def self.config_file
            dot_playwright_dir.join 'config.rb'
          end

          def self.create_file_structure
            FileUtils.mkdir_p(plays_dir)
            FileUtils.touch(config_file)
          end

          def self.path
            ENV['PATH'].split(':')
          end

          def self.all_commands_in_path
            @all_commands_in_path ||= path.map do |path_dir|
              Dir["#{path_dir}/*"].map { |executable| executable.split('/').last }
            end.flatten
          end
# ==============================================================================
# LAZY ATTRIBUTES
# ==============================================================================

          def template
            @template ||= Template.new(name: script_name_rb, out_file: executable_file, type: type)
          end

# ==============================================================================
# PATHS & PATH PREDICATES
# ==============================================================================

          def root_dir
            self.class.plays_dir.join script_name
          end

          def root_dir_exists?
            File.exists? root_dir
          end

          def executable_file
            root_dir.join script_name_rb
          end

          def executable_file_exists?
            File.exists? executable_file
          end

          def symlink_file
            self.class.executable_path_dir.join script_name
          end

          def symlink_file_exists?
            File.symlink? symlink_file
          end

          def script_lib_dir
            root_dir.join 'lib'
          end

          def version_subcommand_file
            script_lib_dir.join 'version.rb'
          end

  # ==============================================================================
  # CREATE METHODS
  # ==============================================================================

          def create_script_files
            validate_before_create_script_files!
            self.class.create_file_structure
            FileUtils.mkdir_p root_dir
            display.print "New Directory Created: #{root_dir}"
            FileUtils.touch executable_file
            display.print "New File Created: #{executable_file}"
            create_expanded_files if type == :expanded
          end

          def create_expanded_files
            FileUtils.mkdir_p script_lib_dir
            FileUtils.touch version_subcommand_file
          end

          def set_permissions
            FileUtils.chmod "u+x", executable_file
            display.print "Executable Permissions Set: #{executable_file}"
          end

          def write_template
            template.render
            if type == Template::EXPANDED_TYPE
              new_template = Template.new(
                name: 'version.rb',
                out_file: version_subcommand_file,
                type: Template::SUBCOMMAND_TYPE,
                klass_name: template.klass_name
              )
              new_template.render
            end
          end

          def create_symlink
            FileUtils.symlink(executable_file, symlink_file)
            display.print "New Symlink Created: #{symlink_file} from #{executable_file}"
          end

          def validate_before_create_script_files!
            if self.class.all_commands_in_path.include?(script_name)
              display.error "There is already a script in your $PATH with that name!"
            elsif executable_file_exists?
              if ask.boolean_question "This playwright script already exists! Overwrite it?"
                delete_playwright_script
              else
                display.abort "Aborting Operation."
              end
            end
          end

          def git_init
            git = Git.init root_dir.to_s
            git.add all: true
            git.commit('initial commit')
          end

          def create_gitignore
            File.open root_dir.join(".gitignore"), "w+" do |file|
              file.write GITIGNORE.join("\n")
            end
          end

          def create_readme
            FileUtils.touch root_dir.join("README.md")
            new_template = Template.new(
              name: script_name,
              out_file: root_dir.join("README.md"),
              type: Template::README_TYPE
            )
            new_template.render
          end

  # ==============================================================================
  # DELETE METHODS
  # ==============================================================================

          def delete_script_files
            validate_before_delete_script_files!
            FileUtils.rm_rf root_dir
            FileUtils.rm symlink_file
            display.print "Playwright script '#{script_name}' destroyed!"
          end

          def validate_before_delete_script_files!
            if symlink_file_exists? && !root_dir_exists?
              display.error "The script named '#{script_name}' is not a playright script!"
            elsif !root_dir_exists?
              display.error "No play with that name exists!"
            end
          end

        end
      end
    end
  end
end
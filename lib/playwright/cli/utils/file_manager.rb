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
          CONFIG_YML = {
            ruby_version: RUBY_VERSION
          }

          def initialize script_name: nil, type: nil
            @script_name = script_name
            @type = type
          end

          def install_script script_name:, type:
            @script_name = script_name
            @type = type
            create_script_files
            symlink_ruby_version
            set_permissions
            write_templates
            create_symlinks
            create_config_yml
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
            "#{script_name.to_snake_case}.rb"
          end

          def script_name_sh
            "#{script_name}.sh"
          end

          def list_scripts
            Dir.new(self.class.plays_dir).select do |file_or_dir|
              Dir.exists?(self.class.plays_dir.join(file_or_dir)) &&
                !['..', '.'].include?(file_or_dir)
            end
          end

          private

          def self.playwright_parent_dir
            Pathname.new Playwright::CLI.configuration.home_dir
          end

          def self.executable_path_dir
            Pathname.new Playwright::CLI.configuration.executable_path_dir
          end

          def self.dot_playwright_dir
            playwright_parent_dir.join '.playwright'
          end

          def self.plays_dir
            dot_playwright_dir.join 'plays'
          end

          def self.root_config_file
            dot_playwright_dir.join 'config.rb'
          end

          def self.rubies_dir
            dot_playwright_dir.join 'rubies'
          end

          def self.create_file_structure
            FileUtils.mkdir_p plays_dir
            FileUtils.touch root_config_file
            FileUtils.mkdir_p rubies_dir
          end

          def self.path
            ENV['PATH'].split ':'
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
            @template ||= Template.new name: script_name, out_file: root_ruby_file, type: type
          end

# ==============================================================================
# PATHS & PATH PREDICATES
# ==============================================================================

          def root_dir
            self.class.plays_dir.join script_name
          end

          def bin_dir
            root_dir.join 'bin'
          end

          def gems_dir
            root_dir.join 'gems'
          end

          def root_dir_exists?
            File.exists? root_dir
          end

          def root_ruby_file
            root_dir.join script_name_rb
          end

          def root_ruby_file_exists?
            File.exists? root_ruby_file
          end

          def launch_script_file
            bin_dir.join script_name_sh
          end

          def launch_script_file_exists?
            File.exists? launch_script_file
          end

          def config_yml_file
            root_dir.join 'config.yml'
          end

          def config_yml_file_exists?
            File.exists? config_yml_file
          end

          def symlink_file
            self.class.executable_path_dir.join script_name
          end

          def symlink_file_exists?
            File.symlink? symlink_file
          end

          def local_symlink_file
            root_dir.join script_name
          end

          def local_symlink_file_exists?
            File.symlink? symlink_file
          end

          def ruby_version_symlink_file
            self.class.rubies_dir.join "ruby#{ RUBY_VERSION.gsub '.', '' }"
          end

          def ruby_version_symlink_file_exists?
            File.symlink? ruby_version_symlink_file
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

          def symlink_ruby_version
            current_ruby = `which ruby`.chomp
            FileUtils.symlink current_ruby, ruby_version_symlink_file unless ruby_version_symlink_file_exists?
            display.print "New Symlink Created: #{ruby_version_symlink_file} from #{current_ruby}"
          end

          def create_script_files
            validate_before_create_script_files!
            self.class.create_file_structure

            FileUtils.mkdir_p root_dir
            display.print "New Directory Created: #{root_dir}"

            FileUtils.mkdir_p gems_dir
            display.print "New Directory Created: #{gems_dir}"

            FileUtils.mkdir_p bin_dir
            display.print "New Directory Created: #{bin_dir}"

            FileUtils.touch root_ruby_file
            display.print "New File Created: #{root_ruby_file}"

            FileUtils.touch launch_script_file
            display.print "New File Created: #{launch_script_file}"

            create_expanded_files if type == :expanded
          end

          def create_expanded_files
            FileUtils.mkdir_p script_lib_dir
            FileUtils.touch version_subcommand_file
          end

          def set_permissions
            FileUtils.chmod "u+x", root_ruby_file
            display.print "Executable Permissions Set: #{root_ruby_file}"
            FileUtils.chmod "u+x", launch_script_file
            display.print "Executable Permissions Set: #{launch_script_file}"
          end

          def write_templates
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
            launch_script_file_template = Template.new(
              name: script_name_sh,
              out_file: launch_script_file,
              type: Template::SHELL_SCRIPT_TYPE,
              values: {
                script_name: script_name
              }
            )
            launch_script_file_template.render
          end

          def create_symlinks
            FileUtils.symlink launch_script_file, symlink_file
            display.print "New Symlink Created: #{symlink_file} from #{launch_script_file}"

            FileUtils.symlink root_ruby_file, local_symlink_file
            display.print "New Symlink Created: #{local_symlink_file} from #{root_ruby_file}"
          end

          def validate_before_create_script_files!
            if self.class.all_commands_in_path.include? script_name
              display.error "There is already a script in your $PATH with that name!"
            elsif root_ruby_file_exists?
              if ask.boolean_question "This playwright script already exists! Overwrite it?"
                delete_script_files
              else
                display.abort "Aborting Operation."
              end
            end
          end

          def git_init
            git = Git.init root_dir.to_s
            git.add all: true
            git.commit 'initial commit'
          end

          def create_gitignore
            File.open root_dir.join(".gitignore"), "w+" do |file|
              file.write GITIGNORE.join("\n")
            end
          end

          def create_config_yml
            File.open config_yml_file, "w+" do |file|
              file.write CONFIG_YML.to_yaml
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
            FileUtils.rm_rf root_dir if Dir.exists? root_dir
            FileUtils.rm symlink_file if File.symlink? symlink_file
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
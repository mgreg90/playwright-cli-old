require 'playwright/cli/utils/ask'
require 'playwright/cli/utils/display'
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

          VALID_TYPES = [Template::SIMPLE_TYPE, Template::COMPLEX_TYPE]

          attr_reader :script_name, :type

          def initialize script_name: nil, type: nil
            @script_name = script_name
            @type = type
          end

          def install_script script_name:, type: Template::SIMPLE_TYPE
            raise ArgumentError, "Invalid Type!" unless VALID_TYPES.include?(type)
            @script_name = script_name
            @type = type
            create_script_files
            set_permissions
            write_template
            create_symlink
            open_editor
          end

          def uninstall_script script_name
            @script_name = script_name
            delete_script_files
          end

          def open_editor script_name: nil
            @script_name ||= script_name
            `$EDITOR #{root_dir}`
            if $?.success?
              display.color_print "Opening `#{@script_name}` in your editor..."
            else
              display.error "Could not open Editor!"
            end
          end

          def script_name_rb
            "#{script_name}.rb"
          end

          private

          def self.playwright_parent_dir
            Playwright::CLI.configuration.home_dir
          end

          def self.executable_path_dir
            Playwright::CLI.configuration.executable_path_dir
          end

          def self.dot_playwright_dir
            File.join playwright_parent_dir, '.playwright'
          end

          def self.plays_dir
            File.join dot_playwright_dir, 'plays'
          end

          def self.config_file
            File.join dot_playwright_dir, 'config.rb'
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
            @template ||= Template.new(name: script_name_rb, out_file: executable_file)
          end

# ==============================================================================
# PATHS & PATH PREDICATES
# ==============================================================================

          def root_dir
            File.join self.class.plays_dir, script_name
          end

          def root_dir_exists?
            File.exists? root_dir
          end

          def executable_file
            File.join root_dir, script_name_rb
          end

          def executable_file_exists?
            File.exists? executable_file
          end

          def symlink_file
            File.join self.class.executable_path_dir, script_name
          end

          def symlink_file_exists?
            File.symlink? symlink_file
          end

  # ==============================================================================
  # CREATE METHODS
  # ==============================================================================

          def create_script_files
            validate_before_create_script_files!
            self.class.create_file_structure
            FileUtils.mkdir_p root_dir
            display.color_print "New Directory Created: #{root_dir}"
            FileUtils.touch executable_file
            display.color_print "New File Created: #{executable_file}"
          end

          def set_permissions
            FileUtils.chmod "u+x", executable_file
            display.color_print "Executable Permissions Set: #{executable_file}"
          end

          def write_template
            template.render
          end

          def create_symlink
            FileUtils.symlink(executable_file, symlink_file)
            display.color_print "New Symlink Created: #{symlink_file} from #{executable_file}"
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

  # ==============================================================================
  # DELETE METHODS
  # ==============================================================================

          def delete_script_files
            validate_before_delete_script_files!
            FileUtils.rm_rf root_dir
            FileUtils.rm symlink_file
            display.color_print "Playwright script '#{script_name}' destroyed!"
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
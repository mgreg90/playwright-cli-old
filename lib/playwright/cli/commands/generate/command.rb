module Playwright
  module CLI
    module Commands
      extend Hanami::CLI::Registry

      class Generate < Hanami::CLI::Command
        class Command
          include Utils::Display
          include Utils::Ask
          include Utils::ScriptFiles

          TEMPLATE_FILE = 'new_script.erb'.freeze
          PATH_BIN_DIR = File.join('/', 'usr', 'local', 'bin').freeze

          def self.run(name)
            new(name).run
          end

          def initialize(name)
            @template = Playwright::CLI::Template.new(file: TEMPLATE_FILE, script_name: name)
            @name = name
          end

          def run
            valid? do
              create_script
              set_permissions
              symlink_into_path
              open_editor
            end
          end

          private

          def valid?
            validate!
            yield
          end

          def validate!
            if symlink_path_and_file? && !script_path_and_file?
              display.error "There is already a script in your #{PATH_BIN_DIR} with that name!"
            elsif script_path_and_file?
              if ask.boolean_question "This playwright script already exists! Overwrite it?"
                delete_playwright_script
              else
                display.abort "Aborting Operation."
              end
            end
            true
          end

          def create_script
            if script_path_and_file?
              display.error "This script already exists!"
            end
            FileUtils.mkdir_p(Playwright::CLI::PLAYS_BIN_PATH)
            FileUtils.touch(script_path_and_file)
            File.write(script_path_and_file, @template.render)
            display.color_print "New File Created: #{script_path_and_file}"
          end

          def set_permissions
            FileUtils.chmod "u+x", script_path_and_file
            display.color_print "Executable Permissions Set!"
          end

          def symlink_into_path
            delete_symlink_path_file
            FileUtils.symlink(script_path_and_file, symlink_path_and_file)
            display.color_print "Symlink Created!"
          end

          def open_editor
            `$EDITOR #{script_path_and_file}`
            if $?.success?
              display.color_print "Opening script in your editor..."
            else
              display.error "Could not open Editor!"
            end
          end

        end
      end
    end
  end
end
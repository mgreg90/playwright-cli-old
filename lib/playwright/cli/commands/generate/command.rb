module Playwright
  module CLI
    module Commands
      extend Hanami::CLI::Registry

      class Generate < Hanami::CLI::Command
        class Command
          TEMPLATE_FILE = 'new_script.erb'.freeze
          PATH_BIN_DIR = File.join('/', 'usr', 'local', 'bin').freeze
          DEFAULT_COLOR = :green

          def self.run(name)
            new(name).run
          end

          def initialize(name)
            @template = Playwright::CLI::Template.new(file: TEMPLATE_FILE, script_name: name)
            @name = name
          end

          def run
            create_script
            set_permissions
            symlink_into_path
            open_editor
          end
          
          private

          def create_script
            if File.exists?(script_path)
              error "This script already exists!"
            end

            FileUtils.mkdir_p(Playwright::CLI::PLAYS_BIN_PATH)
            FileUtils.touch(script_path)
            File.write(script_path, @template.render)
            color_print "New File Created: #{script_path}"
          end
          
          def set_permissions
            FileUtils.chmod "u+x", script_path
            color_print "Executable Permissions Set!"
          end
          
          def symlink_into_path
            symlink_path = File.join(PATH_BIN_DIR, @name)
            FileUtils.symlink(script_path, symlink_path)
          end

          def open_editor
            `$EDITOR #{script_path}`
            if $?.success?
              color_print "Opening script in your editor..."
            else
              error "Could not open Editor!"
            end
          end

          def script_path
            File.join Playwright::CLI::PLAYS_BIN_PATH, @name
          end

          def error msg, msg2 = nil
            color_print msg, color: :red
            color_print "Action Cancelled.", color: :red
            color_print msg2, color: :red if msg2
            exit
          end

          def color_print str, method: :puts, color: DEFAULT_COLOR
            str = str.send(color) if defined?(Colorize)
            send(method, str)
          end

        end
      end
    end
  end
end
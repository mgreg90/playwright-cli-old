module Playwright
  class CLI < Hanami::CLI
    module Commands
      extend Hanami::CLI::Registry

      class Destroy < Hanami::CLI::Command
        class Command
          include Utils::Display
          include Utils::ScriptFiles

          TEMPLATE_FILE = 'new_script.erb'.freeze
          PATH_BIN_DIR = File.join('/', 'usr', 'local', 'bin').freeze
          DEFAULT_COLOR = :green

          def self.run(name)
            new(name).run
          end

          def initialize(name)
            @name = name
          end

          def run
            valid? do
              destroy_script
            end
          end

          private

          def valid?
            validate!
            yield
          end

          def validate!
            if !script_path_and_file?
              display.error "#{@name} is not a playwright script!"
            end
          end

          def destroy_script
            delete_playwright_script
            display.color_print "Playwright script \"#{@name}\" destroyed!"
          end

        end
      end
    end
  end
end
module Playwright
  class CLI < Hanami::CLI
    module Commands
      extend Hanami::CLI::Registry

      class Edit < Hanami::CLI::Command
        class Command
          include Utils::Display
          include Utils::ScriptFiles

          def self.run(name)
            new(name).run
          end

          def initialize(name)
            @name = name
          end

          def run
            valid? do
              open_editor
            end
          end

          private

          def valid?
            validate!
            yield
          end

          def validate!
            if !symlink_path_and_file?
              display.error "#{@name} does not exist!"
            elsif symlink_path_and_file? && !script_path_and_file?
              display.error "#{@name} is not a playwright script!"
            end
            true
          end

        end
      end
    end
  end
end
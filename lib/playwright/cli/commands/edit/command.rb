module Playwright
  class CLI < Hanami::CLI
    module Commands
      extend Hanami::CLI::Registry

      class Edit < Hanami::CLI::Command
        class Command
          include Utils::Display
          include Utils::FileManager

          def self.run(name)
            new(name).run
          end

          def initialize(name)
            @name = name
          end

          def run
            file_manager.open_editor script_name: @name
          end

        end
      end
    end
  end
end
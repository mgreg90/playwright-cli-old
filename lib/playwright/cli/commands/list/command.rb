module Playwright
  class CLI < Hanami::CLI
    module Commands
      extend Hanami::CLI::Registry

      class List < Hanami::CLI::Command
        class Command
          include Utils::Display
          include Utils::Ask
          include Utils::FileManager

          def self.run
            new.run
          end

          def run
            display.print "Playwright Scripts:\n"
            display.print file_manager.list_scripts, indent: true
          end

        end
      end
    end
  end
end
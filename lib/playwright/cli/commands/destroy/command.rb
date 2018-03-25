module Playwright
  class CLI < Hanami::CLI
    module Commands
      extend Hanami::CLI::Registry

      class Destroy < Hanami::CLI::Command
        class Command
          include Utils::Display
          include Utils::FileManager

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
            file_manager.uninstall_script @name
          end

        end
      end
    end
  end
end
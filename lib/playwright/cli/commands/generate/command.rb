require 'playwright/cli/template'

module Playwright
  class CLI < Hanami::CLI
    module Commands
      extend Hanami::CLI::Registry

      class Generate < Hanami::CLI::Command
        class Command
          include Utils::Display
          include Utils::Ask
          include Utils::FileManager

          TEMPLATE_FILE = 'new_script.erb'.freeze
          PATH_BIN_DIR = File.join('/', 'usr', 'local', 'bin').freeze

          def self.run(name, type)
            new(name, type).run
          end

          def initialize(name, type)
            @name = name
            @type = type
          end

          def run
            file_manager.install_script script_name: @name, type: @type
          end

        end
      end
    end
  end
end
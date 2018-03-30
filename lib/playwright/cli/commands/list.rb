require 'playwright/cli/commands/list/command'

module Playwright
  class CLI < Hanami::CLI
    module Commands
      extend Hanami::CLI::Registry

      class List < Hanami::CLI::Command
        desc "Lists all available playwright commands."

        def call(**)
          Command.run
        end
      end

    end
  end
end
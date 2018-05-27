require 'playwright/cli/commands/signup/command'

module Playwright
  class CLI < Hanami::CLI
    module Commands
      extend Hanami::CLI::Registry

      class Signup < Hanami::CLI::Command
        desc "Creates a user in the Playwright Server"

        def call(**)
          Command.run
        end
      end

    end
  end
end
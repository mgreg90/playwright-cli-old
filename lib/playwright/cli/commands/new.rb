module Playwright
  module CLI
    module Commands
      extend Hanami::CLI::Registry
      class New < Hanami::CLI::Command
        def call(*)
        end
      end
    end
  end
end

Playwright::CLI::Commands.register "v", Playwright::CLI::Commands::New
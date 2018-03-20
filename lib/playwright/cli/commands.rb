
module Playwright
  module CLI
    module Commands
      extend Hanami::CLI::Registry
      require 'playwright/cli/commands/new'
      require 'playwright/cli/commands/version'
    end
  end
end

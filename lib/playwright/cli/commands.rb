module Playwright
  module CLI
    module Commands
      extend Hanami::CLI::Registry
      require 'playwright/cli/commands/version'
      require 'playwright/cli/commands/generate'

      register "generate", Generate, aliases: ['g', 'new']
      register "version", Version, aliases: ['v', '-v', '--version']
    end
  end
end

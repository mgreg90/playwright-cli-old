module Playwright
  module CLI
    module Commands
      extend Hanami::CLI::Registry
      require 'playwright/cli/commands/version'
      require 'playwright/cli/commands/generate'
      require 'playwright/cli/commands/destroy'

      register "version", Version, aliases: ['v', '-v', '--version']
      register "generate", Generate, aliases: ['g', 'new']
      register "destroy", Destroy, aliases: ['delete', 'd']
    end
  end
end

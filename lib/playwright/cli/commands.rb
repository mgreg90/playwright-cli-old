require 'playwright/cli/registry'

module Playwright
  class CLI < Hanami::CLI
    module Commands
      extend Playwright::CLI::Registry
      require 'playwright/cli/commands/destroy'
      require 'playwright/cli/commands/edit'
      require 'playwright/cli/commands/generate'
      require 'playwright/cli/commands/list'
      require 'playwright/cli/commands/signup'
      require 'playwright/cli/commands/version'

      register "destroy", Destroy, aliases: ['delete', 'd']
      register "edit", Edit, aliases: ['e']
      register "generate", Generate, aliases: ['g', 'new']
      register "list", List, aliases: ['-l', '--list', 'l']
      register "signup", Signup
      register "version", Version, aliases: ['v', '-v', '--version']
    end
  end
end

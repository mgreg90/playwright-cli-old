require 'playwright/cli/commands/edit/command'

module Playwright
  class CLI < Hanami::CLI
    module Commands
      extend Hanami::CLI::Registry

      class Edit < Hanami::CLI::Command
        desc "Opens your editor to playwright command."

        argument :name, required: true, desc: 'Script name'

        example [
          "my-script # opens your editor to my-script"
        ]

        def call(name: nil, **)
          Command.run(name)
        end
      end

    end
  end
end
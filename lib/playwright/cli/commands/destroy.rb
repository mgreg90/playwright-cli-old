require 'playwright/cli/commands/destroy/command'

module Playwright
  class CLI < Hanami::CLI
    module Commands
      extend Hanami::CLI::Registry

      class Destroy < Hanami::CLI::Command
        desc "Delets a playwright command."

        argument :name, required: true, desc: 'Script name'

        example [
          "my-new-script\n# deletes the script with that name"
        ]

        def call(name: nil, **)
          Command.run(name)
        end
      end

    end
  end
end
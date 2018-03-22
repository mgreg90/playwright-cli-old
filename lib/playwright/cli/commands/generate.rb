require 'playwright/cli/commands/generate/command'

module Playwright
  module CLI
    module Commands
      extend Hanami::CLI::Registry

      class Generate < Hanami::CLI::Command
        desc "Builds a template for a new playwright command."

        argument :name, required: true, desc: 'Script name'

        example [
          "my-new-script\n# script will be called with my-new-script\n# class will be called MyNewScript"
        ]

        def call(name: nil, **)
          Command.run(name)
        end
      end

    end
  end
end
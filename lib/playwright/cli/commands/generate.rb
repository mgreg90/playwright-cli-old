require 'playwright/cli/commands/generate/command'

module Playwright
  class CLI < Hanami::CLI
    module Commands
      extend Hanami::CLI::Registry

      class Generate < Hanami::CLI::Command
        desc "Builds a template for a new playwright command."

        argument :name, required: true, desc: 'Script name'
        option :expanded, type: :boolean, default: false, desc: 'Use this if you will have subcommands'

        example [
          "my-new-script\n# script will be called with my-new-script\n# class will be called MyNewScript"
        ]

        def call(name:, expanded:, **)
          Command.run(name, type(expanded))
        end

        def type expanded
          expanded ? :expanded : :simple
        end
      end

    end
  end
end
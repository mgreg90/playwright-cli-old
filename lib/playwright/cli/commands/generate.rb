require 'playwright/cli/commands/generate/command'

module Playwright
  class CLI < Hanami::CLI
    module Commands
      extend Hanami::CLI::Registry

      class Generate < Hanami::CLI::Command
        desc "Builds a template for a new playwright command."

        argument :name, required: true, desc: 'Script name'
        option :type, default: 'simple', values: %w[ expanded simple ]

        example [
          "my-new-script\n# script will be called with my-new-script\n# class will be called MyNewScript"
        ]

        def call(name:, type:, **)
          Command.run(name, type.to_sym)
        end
      end

    end
  end
end
module Playwright
  module CLI
    module Commands
      extend Hanami::CLI::Registry

      class Version < Hanami::CLI::Command
        desc "Print version"

        def call(*)
          puts VERSION
        end
      end
      register "version", Version, aliases: ['v', '-v', '--version']

    end
  end
end
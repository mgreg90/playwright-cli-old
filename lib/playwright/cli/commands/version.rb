module Playwright
  class CLI < Hanami::CLI
    module Commands
      extend Hanami::CLI::Registry

      class Version < Hanami::CLI::Command
        desc "Print version."

        def call(*)
          puts VERSION
        end
      end

    end
  end
end
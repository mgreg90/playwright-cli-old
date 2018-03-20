require 'hanami/cli'

module Playwright
  module CLI
    require "playwright/cli/commands"
    require "playwright/cli/version"

    def self.call(*args)
      Hanami::CLI.new(Commands).call(*args)
    end

  end
end

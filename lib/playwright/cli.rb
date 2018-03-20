require "playwright/cli/version"

module Playwright
  module Cli
    def self.echo *args
      puts args
    end
  end
end

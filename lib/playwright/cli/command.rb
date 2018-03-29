require 'playwright/cli/utils'

module Playwright
  class CLI < Hanami::CLI
    class Command < Hanami::CLI::Command
      include CLI::Utils::Ask
      include CLI::Utils::Display
    end
  end
end
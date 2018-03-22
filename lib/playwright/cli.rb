require 'hanami/cli'
require 'colorize'
require 'fileutils'
require 'erb'

module Playwright
  module CLI
    ROOT_PATH = File.expand_path('../..', File.dirname(__FILE__))
    PLAYS_PATH = File.join(ROOT_PATH, 'plays')
    PLAYS_BIN_PATH = File.join(PLAYS_PATH, 'bin')
    TEMPLATES_PATH = File.join(ROOT_PATH, 'lib', 'assets', 'templates')

    require "playwright/cli/commands"
    require "playwright/cli/template"
    require "playwright/cli/version"

    def self.call(*args)
      Hanami::CLI.new(Commands).call(*args)
    end

  end
end

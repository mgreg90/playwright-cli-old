require 'hanami/cli'
require 'colorize'
require 'fileutils'
require 'erb'

# TODO: Remove this
require 'pry'

module Playwright
  class CLI < Hanami::CLI
    ROOT_PATH = File.expand_path('../..', File.dirname(__FILE__))
    PLAYS_PATH = File.join(ROOT_PATH, 'plays')
    PLAYS_BIN_PATH = File.join(PLAYS_PATH, 'bin')
    TEMPLATES_PATH = File.join(ROOT_PATH, 'lib', 'assets', 'templates')

    require "playwright/cli/utils"
    require "playwright/cli/commands"
    require "playwright/cli/registry"
    require "playwright/cli/template"
    require "playwright/cli/version"

    def self.call(*args)
      new(Commands).call(*args)
    end
    
    def call(arguments: ARGV, out: $stdout)
      result = commands.get(arguments)
      
      if !result.found? && commands.has_root?
        result = commands.get_root(arguments)
        command, args = parse(result, out)
        command.call(args)
      else
        super(*args)
      end
    end

  end
end

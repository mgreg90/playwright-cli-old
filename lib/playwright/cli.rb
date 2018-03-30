require 'hanami/cli'
require 'colorize'
require 'git'

require 'fileutils'
require 'erb'
require 'os'
require 'uri'
require 'pathname'

# TODO: Remove this
require 'pry'

module Playwright
  class CLI < Hanami::CLI
    ROOT_PATH = Pathname.new(File.expand_path('../..', File.dirname(__FILE__)))
    PLAYS_PATH = ROOT_PATH.join 'plays'
    PLAYS_BIN_PATH = PLAYS_PATH.join 'bin'
    TEMPLATES_PATH = ROOT_PATH.join 'lib', 'assets', 'templates'

    require "playwright/cli/command"
    require "playwright/cli/commands"
    require "playwright/cli/configuration"
    require "playwright/cli/registry"
    require "playwright/cli/template"
    require "playwright/cli/utils"
    require "playwright/cli/version"

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.configure
      yield(configuration)
    end

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

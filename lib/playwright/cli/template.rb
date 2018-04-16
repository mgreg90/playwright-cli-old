require 'playwright/cli/utils/file_manager'

module Playwright
  class CLI < Hanami::CLI
    class Template
      include Utils::Display

      InvalidTemplate = Class.new(StandardError)

      attr_reader :script_name, :out_file, :type, :values

      SIMPLE_TYPE = :simple
      SIMPLE_TEMPLATE = 'simple_script_template.erb'
      EXPANDED_TYPE = :expanded
      EXPANDED_TEMPLATE = 'expanded_script_template.erb'
      SUBCOMMAND_TYPE = :subcommand
      SUBCOMMAND_TEMPLATE = 'version_subcommand_template.erb'
      README_TYPE = :readme
      README_TEMPLATE = 'script_readme_template.erb'
      SHELL_SCRIPT_TYPE = :shell_script,
      SHELL_SCRIPT_TEMPLATE = 'launch_script_template.erb'

      TEMPLATE_MAP = {
        SIMPLE_TYPE => SIMPLE_TEMPLATE,
        EXPANDED_TYPE => EXPANDED_TEMPLATE,
        SUBCOMMAND_TYPE => SUBCOMMAND_TEMPLATE,
        README_TYPE => README_TEMPLATE,
        SHELL_SCRIPT_TYPE => SHELL_SCRIPT_TEMPLATE
      }

      def render(*args)
        new(*args).render
      end

      def initialize(name:, out_file:, type: SIMPLE_TYPE, klass_name: nil, values: {})
        @script_name = name
        @out_file = out_file
        @template_file = Playwright::CLI::TEMPLATES_PATH.join TEMPLATE_MAP[type]
        @klass_name = klass_name
        @values = values
      end

      def klass_name
        @klass_name || @script_name.gsub('.rb', '').split(/[A-Z\-\_\/]/).map(&:capitalize).join
      end

      def render
        contents = File.read(@template_file)
        text = ERB.new(contents).result(binding)
        File.write(out_file, text)
        display.print "Rendered File Contents: #{out_file}"
      end

      def val
        values
      end

    end
  end
end
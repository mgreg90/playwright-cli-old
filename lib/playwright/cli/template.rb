require 'playwright/cli/utils/file_manager'

module Playwright
  class CLI < Hanami::CLI
    class Template

      attr_reader :script_name, :out_file, :type

      SIMPLE_TYPE = :simple
      SIMPLE_TEMPLATE = 'simple_script_template.erb'
      EXPANDED_TYPE = :expanded
      EXPANDED_TEMPLATE = 'expanded_script_template.erb'
      SUBCOMMAND_TYPE = :subcommand
      SUBCOMMAND_TEMPLATE = 'version_subcommand_template.erb'

      TEMPLATE_MAP = {
        SIMPLE_TYPE => SIMPLE_TEMPLATE,
        EXPANDED_TYPE => EXPANDED_TEMPLATE,
        SUBCOMMAND_TYPE => SUBCOMMAND_TEMPLATE
      }

      def initialize(name:, out_file:, type: SIMPLE_TYPE, klass_name: nil)
        @script_name = name
        @out_file = out_file
        @template_file = File.join(Playwright::CLI::TEMPLATES_PATH, TEMPLATE_MAP[type])
        @klass_name = klass_name
      end

      def klass_name
        @klass_name || @script_name.gsub('.rb', '').split(/[A-Z\-\_\/]/).map(&:capitalize).join
      end

      def render
        contents = File.read(@template_file)
        text = ERB.new(contents).result(binding)
        File.write(out_file, text)
      end

    end
  end
end
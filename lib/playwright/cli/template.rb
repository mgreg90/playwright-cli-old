require 'playwright/cli/utils/file_manager'

module Playwright
  class CLI < Hanami::CLI
    class Template

      attr_reader :script_name, :out_file

      SIMPLE_TYPE = :simple_type
      SIMPLE_TEMPLATE = 'new_simple_script.erb'
      COMPLEX_TYPE = :complex_type

      def initialize(name:, out_file:, type: SIMPLE_TYPE)
        @script_name = name
        @out_file = out_file
        if type == SIMPLE_TYPE
          @template_file = File.join(Playwright::CLI::TEMPLATES_PATH, SIMPLE_TEMPLATE)
        else
          raise NotImplementedError
        end
      end

      def klass_name
        @script_name.gsub('.rb', '').split(/[A-Z\-\_\/]/).map(&:capitalize).join
      end

      def render
        contents = File.read(@template_file)
        text = ERB.new(contents).result(binding)
        File.write(out_file, text)
      end

    end
  end
end
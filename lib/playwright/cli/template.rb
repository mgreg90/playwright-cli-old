module Playwright
  class CLI < Hanami::CLI
    class Template

      attr_reader :script_name

      def initialize(file:, script_name:)
        @script_name = script_name
        @file = File.join(Playwright::CLI::TEMPLATES_PATH, file)
      end

      def klass_name
        @script_name.split(/[A-Z\-\_\/]/).map(&:capitalize).join
      end

      def contents
        File.read @file
      end

      def render
        ERB.new(contents).result(binding)
      end

    end
  end
end
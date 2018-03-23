require 'playwright/cli/utils/display'

module Playwright
  module CLI
    module Utils
      module Ask

        def ask
          @ask ||= Ask.new
        end

        class Ask
          include Display

          DEFAULT_COLOR = :blue
          TRUE_RESPONSE = :y
          FALSE_RESPONSE = :n

          def boolean_question question
            display.color_print "#{question} [yn]", color: DEFAULT_COLOR
            response = STDIN.gets.chomp.strip.downcase.to_sym
            boolean_response_map[response]
          end

          private

          def boolean_response_map
            { TRUE_RESPONSE => true, FALSE_RESPONSE => false }
          end

        end
      end
    end
  end
end

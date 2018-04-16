require 'playwright/cli/utils/util'
require 'playwright/cli/utils/display'

module Playwright
  class CLI < Hanami::CLI
    module Utils
      module Ask

        def ask
          @ask ||= Ask.new
        end

        class Ask < Util
          include Display

          DEFAULT_COLOR = :light_blue
          TRUE_RESPONSE = :y
          FALSE_RESPONSE = :n

          def boolean_question user_question
            response = question "#{user_question} [yn]"
            map_boolean_response response
          end

          def url_question user_question
            response = question user_question
            if response =~ URI::regexp
              response
            else
              display.error "Invalid URL!"
            end
          end

          def question user_question
            display.print "#{user_question} ", color: DEFAULT_COLOR, method: :print
            $stdin.gets
          end

          private

          def map_boolean_response value
            { TRUE_RESPONSE => true, FALSE_RESPONSE => false }[sanitize_boolean_response value]
          end

          def sanitize_boolean_response value
            value&.strip&.downcase&.to_sym
          end

        end
      end
    end
  end
end

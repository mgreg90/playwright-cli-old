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
            response = question "#{user question} [yn]"
            sanitized_response = response.chomp.strip.downcase.to_sym if response && response.length > 0
            boolean_response_map[response]
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

          def boolean_response_map
            { TRUE_RESPONSE => true, FALSE_RESPONSE => false }
          end

        end
      end
    end
  end
end

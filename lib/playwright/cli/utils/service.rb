module Playwright
  class CLI < Hanami::CLI
    module Utils
      module Service

        def service
          @service ||= Service.new
        end

        class Service < Util

          BASE_URL = 'http://localhost:3000'
          require 'playwright/cli/utils/service/user'

          def users
            User
          end
        end
      end
    end
  end
end
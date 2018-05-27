module Playwright
  class CLI < Hanami::CLI
    module Utils
      module Service
        class User
          BASE_URL = "#{Service::BASE_URL}/users"

          def self.create(data:)
            HTTParty.post(
              BASE_URL,
              body: data
            )
          end

          private
        end
      end
    end
  end
end
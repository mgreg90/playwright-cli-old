module Playwright
  class CLI < Hanami::CLI
    module Utils
      class Util

        def actions
          self.class.public_instance_methods - Object.public_instance_methods
        end

      end
    end
  end
end
require 'playwright/cli/utils/util'
require 'playwright/cli/utils/display'

module Playwright
  class CLI < Hanami::CLI
    module Utils
      module OS

        def os
          @os ||= OS.new
        end

        class OS < Util
          include Display

          def open_url url:, name: URI(url).host
            if %x[ #{::OS.open_file_command} #{url} ]
              display.print "Opening #{name} in your default browser..."
            else
              display.error "Failed to open your browser!"
            end
          end

          def open_editor path:, name: Pathname.new(path).base
            if %x[ $EDITOR #{path} ]
              display.print "Opening #{name} in your default editor..."
            else
              display.error "Failed to open your editor!"
            end
          end

        end
      end
    end
  end
end
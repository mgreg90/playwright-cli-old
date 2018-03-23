module Playwright
  module CLI
    module Utils
      module Display

        def display
          @display ||= Display.new
        end

        class Display
          
          InvalidPrintMethod = Class.new StandardError

          VALID_PRINT_METHODS = [:p, :puts, :print]
          DEFAULT_COLOR = :green
          WARNING_COLOR = :yellow
          ERROR_COLOR = :red

          def error msg, msg2 = nil
            color_print msg, color: :red
            color_print "Action Cancelled.", color: ERROR_COLOR
            color_print msg2, color: ERROR_COLOR if msg2
            exit
          end

          def abort msg = nil
            color_print msg, color: WARNING_COLOR if msg
            color_print "Action Cancelled.", color: WARNING_COLOR
            exit
          end

          def color_print msg, method: :puts, color: DEFAULT_COLOR
            validate_print_method!(method)
            msg = msg.send(color) if defined?(Colorize)
            send(method, msg)
          end

          private

          def validate_print_method!(method)
            raise InvalidPrintMethod unless VALID_PRINT_METHODS.include? method.to_sym
          end

        end
      end
    end
  end
end

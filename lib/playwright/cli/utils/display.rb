module Playwright
  class CLI < Hanami::CLI
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
            print msg, color: :red
            print "Action Cancelled.", color: ERROR_COLOR
            print msg2, color: ERROR_COLOR if msg2
            exit 1
          end

          def abort msg = nil
            print msg, color: WARNING_COLOR if msg
            print "Action Cancelled.", color: WARNING_COLOR
            exit 1
          end

          def print msg, method: :puts, color: DEFAULT_COLOR
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

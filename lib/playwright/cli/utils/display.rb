require 'playwright/cli/utils/util'
module Playwright
  class CLI < Hanami::CLI
    module Utils
      module Display

        def display
          @display ||= Display.new
        end

        class Display < Util

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

          def print msg, method: :puts, color: DEFAULT_COLOR, indent: false
            msg = stringify msg, indent: indent
            validate_print_method!(method)
            msg = msg.send(color) if defined?(Colorize)
            send(method, msg)
          end

          private

          def validate_print_method!(method)
            raise InvalidPrintMethod unless VALID_PRINT_METHODS.include? method.to_sym
          end

          def stringify msg, indent: false
            indent = 1 if indent == true
            case msg
            when String
              indent ? indentify(msg, count: indent) : msg
            when Array
              msg = msg.map { |ln| indentify(ln, count: indent) } if indent
              msg.join("\n")
            end
          end

          def indentify msg, count: 0
            "#{"  " * count}#{msg}"
          end

        end
      end
    end
  end
end

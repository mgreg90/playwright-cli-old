module Hanami
  class CLI
    module Parser

      # Copied and adjusted from hanami/cli codebase to handle validations
      def self.call(command, arguments, names)

        command.arguments.map.with_index do |arg, idx|
          arg_value = arguments[idx]
          unless Array.wrap(arg.validations).all? { |validation| validation.call(arg_value) }
            return Result.failure "Error: Invalid argument provided: #{arg_value}"
          end
        end

        parsed_options = {}

        OptionParser.new do |opts|
          command.options.each do |option|
            opts.on(*option.parser_options) do |value|
              # This conditional enforces validations
              if option.validations.all? { |validation| validation.call(value) }
                parsed_options[option.name.to_sym] = value
              else
                return Result.failure "Error: Invalid option provided: #{option.name}"
              end
            end
          end

          opts.on_tail("-h", "--help") do
            return Result.help
          end
        end.parse!(arguments)

        parsed_options = command.default_params.merge(parsed_options)
        parse_required_params(command, arguments, names, parsed_options)
      rescue ::OptionParser::ParseError
        return Result.failure
      end

    end
  end
end
module Hanami
  class CLI
    class Option

      def validations
        options[:validations] || []
      end

    end
  end
end
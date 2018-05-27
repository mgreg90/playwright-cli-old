module Playwright
  class CLI < Hanami::CLI
    module Commands
      extend Hanami::CLI::Registry

      class Signup < Hanami::CLI::Command
        class Command
          include Utils::Display
          include Utils::Ask
          include Utils::Service

          def self.run
            new.run
          end

          def run
            display.border
            display.print "Please enter an email address and password:"
            @email = ask.question "Email: "
            @password = ask.question "Password: "
            create_user
          end

          private

          attr_reader :email, :password

          def create_user
            service.users.create(
              data: {
                email: email,
                password: password
              }
            )
          end

        end
      end
    end
  end
end
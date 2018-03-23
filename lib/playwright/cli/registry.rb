require 'hanami/cli'

module Playwright
  class CLI < Hanami::CLI
    module Registry
      def self.extended base
        base.class_eval do
          extend Hanami::CLI::Registry
          extend ClassMethods
        end
      end
      
      module ClassMethods
        def register_root(*args)
          register(unique_root_string, *args)
          @root_command = true
        end
        
        def has_root?
          !!@root_command
        end
        
        def get_root(arguments)
          get([unique_root_string, *arguments])
        end
        
        private
        
        def unique_root_string
          "05d93d18-a93a-4a80-9556-caf2c835112e"
        end
        
      end
      
    end
  end
end
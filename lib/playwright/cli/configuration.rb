module Playwright
  class CLI
    class Configuration
      attr_accessor :home_dir,
                    :executable_path_dir

      DEFAULT_HOME = ENV['HOME']
      DEFAULT_EXECUTABLE_PATH_DIR = File.join('/', 'usr', 'local', 'bin')

      def initialize
        @home_dir = Pathname.new DEFAULT_HOME
        @executable_path_dir = Pathname.new DEFAULT_EXECUTABLE_PATH_DIR
      end

    end
  end
end
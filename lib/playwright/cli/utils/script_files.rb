module Playwright
  module CLI
    module Utils
      module ScriptFiles

        PATH_BIN_DIR = File.join('/', 'usr', 'local', 'bin').freeze

        def script_path_and_file
          File.join Playwright::CLI::PLAYS_BIN_PATH, @name
        end

        def script_path_and_file?
          File.exists? script_path_and_file
        end

        def symlink_path_and_file
          File.join PATH_BIN_DIR, @name
        end

        def symlink_path_and_file?
          File.exists? symlink_path_and_file
        end

        def delete_playwright_script
          delete_script_file
          delete_symlink_path_file
        end

        def delete_script_file
          FileUtils.rm script_path_and_file  if script_path_and_file?
        end

        def delete_symlink_path_file
          FileUtils.rm symlink_path_and_file if symlink_path_and_file?
        end

      end
    end
  end
end
require "bundler/setup"
require "playwright/cli"
require "memfs"


def suppress_io(config)
  original_stderr = $stderr
  original_stdout = $stdout
  original_stdin  = $stdin
  config.before(:all) do
    # Redirect stderr and stdout
    $stderr = File.open(File::NULL, "w")
    $stdout = File.open(File::NULL, "w")
    $stdin  = File.open(File::NULL, "w+")
  end
  config.after(:all) do
    $stderr = original_stderr
    $stdout = original_stdout
    $stdin  = original_stdin
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Allows you to tag examples with memfs: true to let them use a fake file system
  config.around(:each, memfs: true) do |example|
    MemFs.activate { example.run }
  end

  # Comment out this line to turn input/output back on
  suppress_io(config)

end

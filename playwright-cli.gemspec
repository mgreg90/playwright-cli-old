
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hanami/cli'
require "playwright/cli/version"

Gem::Specification.new do |spec|
  spec.name          = "playwright-cli"
  spec.version       = Playwright::CLI::VERSION
  spec.authors       = ["Mike Gregory"]
  spec.email         = ["mgregory8219@gmail.com"]

  spec.summary       = %q{Playwright is tool for quickly building command line apps in ruby.}
  # spec.description   = %q{}
  spec.homepage      = "https://github.com/mgreg90/playwright-cli"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["documentation_uri"] = "https://github.com/mgreg90/playwright-cli"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler",  "~> 1.16"
  spec.add_development_dependency "rake",     "~> 10.0"
  spec.add_development_dependency "rspec",    "~> 3.0"
  spec.add_development_dependency "pry",      "~> 0.9.0"
  spec.add_development_dependency "pry-nav",  "~> 0.2.4"
  spec.add_development_dependency "memfs",    "~> 1.0"

  spec.add_runtime_dependency "hanami-cli",   "~> 0.1"
  spec.add_runtime_dependency "colorize",     "~> 0.1"
  spec.add_runtime_dependency "os",           "~> 1.0"
  spec.add_runtime_dependency "git",          "~> 1.3"
end

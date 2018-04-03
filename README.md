# Playwright::CLI

Playwright::CLI is a tool for quickly building (and hopefully soon sharing)
Ruby command line applications. It's first goal is to provide a solid generator
for building command line apps in Ruby. It's built on top of [Hanami::CLI](https://github.com/hanami/cli),
so all of their documentation applies here as well.

## Installation

Install this gem with:

    $ gem install playwright-cli

## Usage

### Check The Version

To check the version:
```shell
$ playwright -v #=> 0.1.14
```

### Create An App

To create a simple command line app:

    $ playwright generate my-script

(aliases for `generate` include `g`, `new`)
This will give you some boilerplate for your script and an example command that
you should replace. The `#call` method is what is ultimately run.
It will look something like this:

```ruby
#!/usr/bin/env ruby

require 'bundler/inline'
gemfile do
  source 'https://rubygems.org'
  gem 'playwright-cli', require: 'playwright/cli'
end

module MyScript
  module CLI
    module Commands
      extend Playwright::CLI::Registry

      class Root < Playwright::CLI::Command
        desc "Says a greeting to the name given. This is an example."

        argument :name, required: true, desc: 'Whom shall I greet?'

        example [
          "\"Johnny Boy\" #=> Why, hello Johnny Boy!"
        ]

        def call(name:, **)
          puts "Why, hello #{name}!"
        end

      end

      register_root Root

    end
  end
end

Playwright::CLI.new(MyScript::CLI::Commands).call

```

```shell
$ my-script tom #=> Why, hello tom!
```
Most of this code is simply wrapping [Hanami::CLI](https://github.com/hanami/cli), so their documentation
will be the best source of information for you in handling arguments and options.

You can list any gems you want inside the gemfile block as you would any gemfile.
You won't have to worry about running `bundle`.

All commands must implement a `#call` method and must be registered, either using
`#register` (as in the example below) or `#register_root`. `#register_root` is
for registering the base command. All subcommands are registered with `#register`,
as in the example below.

Hanami::CLI is built for more intricate command line apps, so playwright allows
you to generate that as well.
```shell
$ playwright g my-script --type=expanded
```
This will give you a mostly similar main class:

```ruby
#!/usr/bin/env ruby

require 'bundler/inline'
gemfile do
  source 'https://rubygems.org'
  gem 'playwright-cli', require: 'playwright/cli'
end

require_relative 'lib/version'

module MyScript
  module CLI
    module Commands
      extend Playwright::CLI::Registry

      class Greet < Playwright::CLI::Command
        desc "Says a greeting to the name given. This is an example."

        argument :name, required: true, desc: 'Whom shall I greet?'

        example [
          "\"Johnny Boy\" #=> Why, hello Johnny Boy!"
        ]

        def call(name:, **)
          puts "Why, hello #{name}!"
        end

      end

      register 'greet', Greet
      register 'version', Version, aliases: ['v', '-v', '--version']

    end
  end
end

Playwright::CLI.new(MyScript::CLI::Commands).call
```
It will also give you a new file structure with an example (version) command:
```
  my-script
    |- lib/
    |   |- version.rb
    |- my-script.rb
    |- .git/
    |- .gitignore
    |- README.md
```
The main differences are that a new file lib/version is required and registered
with aliases.

Version class simply looks like this:
```ruby
module MyScript
  module CLI

    VERSION = "0.0.1"

    module Commands
      extend Playwright::CLI::Registry

      class Version < Playwright::CLI::Command
        desc "Responds with the version number."

        example ["#=> #{VERSION}"]

        def call(**)
          puts VERSION
        end

      end

    end
  end
end
```

This is useful for command line apps that will have multiple functions. This
example would let you do:

```shell
$ my-script greet tom #=> Why, hello tom!
$ my-script version #=> 0.0.1
```

### Helpers

Inside of your command, you have access to a few helper objects to make
interactions easier. You can see any of your helpers actions by calling the
`#actions` method on it.

#### Display

The Display helper has 3 actions, `print`, `error`, and `abort`. Each takes a
message as the first argument and can optionally take a color. `error` and
`abort` also exit the program.

`abort` should be used over `error` only if the user has triggered the exit.
A good example would be if you ask a user, "File already exists? Overwrite it?
[yn]" and they choose 'n'

```ruby
class Greet < Playwright::CLI::Command
  def call(**)
    display.print "Hello!", color: :blue
  end
end
```

#### Ask

The Ask helper has 3 actions, `question`, `boolean_question`, and
`url_question`. Each takes a message as the only argument. `boolean_question`
and `url_question` validate the response. `question` does not.

```ruby
class Greet < Playwright::CLI::Command
  def call(**)
    ask.boolean_question "What's your name?" #=> "What's your name? [yn]"
  end
end
```

#### OS

The OS helper has 2 actions, `open_url` and `open_editor`. `open_url` takes a
url and an optional name. `open_editor` takes a path and an optional name.

```ruby
class Greet < Playwright::CLI::Command
  def call(**)
    os.open_url url: 'http://google.com', name: 'google'
    os.open_editor path: Dir.pwd, name: 'working directory'
  end
end
```

### Edit An App

Playwright::CLI uses your `$EDITOR` environment variable when choosing what
editor to use when opening one of your playwright scripts.

Use:

```shell
$ echo $EDITOR
```

To see what playwright will default to. You can update this in your ~/.bashrc
(or ~/.zshrc if you are using zsh).

In the future, I plan on allowing that to be a config you can set

To edit an app:

```shell
$ playwright edit my-script
```

`e` can be used instead of `edit`.

### List Apps

To see all Playwright apps, use:

```shell
$ playwright list
```

`l`, `-l`, `--list` can be used instead of `list`.

### Delete An App

Deleting a playwright app is simply:

```shell
$ playwright destroy my-script
```

`delete` or `d` can be used instead of `destroy`
This works for both simple and expanded apps. It cannot be used to delete or
uninstall existing terminal commands, only playwright commands

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mgreg90/playwright-cli.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

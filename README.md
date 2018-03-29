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
$ playwright -v #=> 0.1.4
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

require 'playwright/cli'

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

Most of this code is simply wrapping [Hanami::CLI](https://github.com/hanami/cli), so their documentation
will be the best source of information for you in handling arguments and options.

So far, only `#register_root` here is a playwright feature. It allows you to
overwrite the root command. In this case that means:
```shell
$ my-script tom #=> Why, hello tom!
```

Hanami::CLI is built for more intricate command line apps, so playwright allows
you to generate that as well.
```shell
$ playwright g my-script --type=expanded
```
This will give you a mostly similar main class:

```ruby
#!/usr/bin/env ruby

require 'playwright/cli'
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


### Edit An App

Playwright::CLI uses your `$EDITOR` environment variable when choosing what
editor to use when opening one of your playwright scripts.

Use:

`$ echo $EDITOR`

To see what playwright will default to. You can update this in your ~/.bashrc
(or ~/.zshrc if you are using zsh).

In the future, I plan on allowing that to be a config you can set

To edit an app:

`$ playwright edit my-script`

`e` can be used instead of `edit`.

### Delete An App

Deleting a playwright app is simply:

```shell
$ playwright destroy my-script
```

`delete` or `d` can be used instead of `destroy`
This works for both simple and expanded apps. It cannot be used to delete or
uninstall existing terminal commands, only playwright commands

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/playwright-cli.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

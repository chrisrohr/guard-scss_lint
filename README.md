[![Gem Version](http://img.shields.io/gem/v/guard-scss_lint.svg)](http://badge.fury.io/rb/guard-scss_lint)
[![Dependency Status](http://img.shields.io/gemnasium/chrisrohr/guard-scss_lint.svg)](https://gemnasium.com/chrisrohr/guard-scss_lint)
[![Build Status](https://travis-ci.org/chrisrohr/guard-scss_lint.svg?branch=master)](https://travis-ci.org/chrisrohr/guard-scss_lint)
[![Coverage Status](http://img.shields.io/coveralls/chrisrohr/guard-scss_lint/master.svg)](https://coveralls.io/r/chrisrohr/guard-scss_lint)
[![Code Climate](http://img.shields.io/codeclimate/github/chrisrohr/guard-scss_lint.svg)](https://codeclimate.com/github/chrisrohr/guard-scss_lint)

# guard-scss_lint

A guard to lint your SCSS.

This guard plugin is a fork of the originally created [guard-scss-lint](https://github.com/chrislopresto/guard-scss-lint) plugin by Chris LoPresto.  This version has been modified to conform to the ruby gems naming standard as well as supports the latest versions of Scss Lint.

## Installation

Please make sure you have [Guard](https://github.com/guard/guard) installed before continue.

Add `guard-scss_lint` to your `Gemfile`:

```ruby
group :development do
  gem 'guard-scss_lint'
end
```

and then execute:

```sh
$ bundle install
```

or install it yourself as:

```sh
$ gem install guard-scss_lint
```

Add the default Guard::ScssLint definition to your `Guardfile` by running:

```sh
$ guard init scss_lint
```

## Usage

Please read the [Guard usage documentation](https://github.com/guard/guard#readme).

## Options

You can pass some options in `Guardfile` like the following example:

```ruby
guard :scss_lint, all_on_start: false, config: '.custom-scss-lint.yml' do
  # ...
end
```

### Available Options

```ruby
all_on_start: true    # Check all files at Guard startup.
                      #  default: true
config: 'filename'    # Location of custom scss lint configuration file.
                      #  default: nil (Uses .scss-lint.yml file or SCSSLint defaults)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Copyright (c) 2015 Chris Rohr

See the [LICENSE](LICENSE) for details.
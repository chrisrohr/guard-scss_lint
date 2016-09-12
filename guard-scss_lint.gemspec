# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'guard/scss_lint/version'

Gem::Specification.new do |spec|
  spec.name          = 'guard-scss_lint'
  spec.version       = Guard::ScssLintVersion::VERSION
  spec.authors       = ['Chris Rohr']
  spec.email         = ['rohr.chris@gmail.com']
  spec.summary       = %q{Guard plugin for scss_lint}
  spec.description   = %q{A Guard plugin to lint your .scss files using scss_lint. SCSS Lint changed from scss-lint to scss_lint and this is the guard update for that.}
  spec.homepage      = 'https://github.com/chrisrohr/guard-scss_lint'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_path  = 'lib'

  # spec.add_dependency 'guard', '~> 2.2'
  spec.add_dependency 'guard-compat', '~> 1.1'
  spec.add_dependency 'scss_lint', '~> 0.43'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-nav'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'guard-rubocop'
end

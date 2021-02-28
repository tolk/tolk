$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "tolk/version"

Gem::Specification.new do |s|
  s.name        = 'tolk'
  s.version     = Tolk::VERSION
  s.summary     = 'Tolk is a Rails Engine that provides a web interface for editing I18n translations.'
  s.description = s.summary
  s.license = 'MIT'

  s.authors = ['David Heinemeier Hansson', 'Piotr Sarnacki', 'Emilio Tagua', 'Thomas Darde', 'Ferran Basora']
  s.email = 'david@loudthinking.com'
  s.homepage = 'https://github.com/tolk/tolk'

  s.platform = Gem::Platform::RUBY

  s.required_ruby_version = '>= 2.3.0'

  s.add_runtime_dependency 'rails', '>= 5.0'
  s.add_runtime_dependency 'safe_yaml', ">= 0.8.6"
  s.add_runtime_dependency 'sassc'

  s.add_development_dependency 'capybara', '~> 2.14'
  s.add_development_dependency 'sqlite3', '~> 1.3', '< 1.5'
  s.add_development_dependency 'mocha', '>= 1.0'
  s.add_development_dependency 'poltergeist'
  s.add_development_dependency 'will_paginate'

  s.files = Dir['README', 'MIT-LICENSE', 'config/**/*', 'init.rb', 'lib/**/*', 'app/**/*', 'public/tolk/**/*']

  s.require_path = 'lib'
end

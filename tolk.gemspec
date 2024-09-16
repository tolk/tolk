$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "tolk/version"

Gem::Specification.new do |s|
  s.name        = 'tolk'
  s.version     = Tolk::VERSION
  s.summary     = 'Rails engine providing web interface for managing i18n yaml files'
  s.description = 'Tolk is a web interface for doing i18n translations packaged as an engine for Rails applications.'
  s.license = 'MIT'

  s.authors = ['David Heinemeier Hansson', 'Piotr Sarnacki', 'Emilio Tagua', 'Thomas Darde', 'Ferran Basora']
  s.email = 'david@loudthinking.com'
  s.homepage = 'https://github.com/tolk/tolk'

  s.platform = Gem::Platform::RUBY

  s.required_ruby_version = ">= 3.0.0"

  s.add_runtime_dependency "rails", ">= 7.0", "< 7.3"




  s.add_development_dependency "sprockets-rails", "~> 3.4"
  s.add_development_dependency 'sqlite3', '>= 1.3'
  s.add_development_dependency 'mocha', '>= 1.0'
  s.add_development_dependency 'will_paginate'
  s.add_development_dependency 'rake', "~> 13.0"
  s.add_development_dependency "capybara", "~> 3.14"
  s.add_development_dependency "cuprite"
  s.add_development_dependency "sassc"
  s.add_development_dependency "puma", "~> 6.0"
  s.add_development_dependency "appraisal"

  if File.exist?('UPGRADING')
    s.post_install_message = File.read("UPGRADING")
  end

  s.files = Dir['README', 'MIT-LICENSE', 'config/**/*', 'init.rb', 'lib/**/*', 'app/**/*', 'public/tolk/**/*']

  s.require_path = 'lib'
end

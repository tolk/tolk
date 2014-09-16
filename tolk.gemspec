# encoding: utf-8
require File.expand_path('../lib/tolk/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'tolk'
  s.version     = Tolk::VERSION
  s.summary     = 'Rails engine providing web interface for managing i18n yaml files'
  s.description = 'Tolk is a web interface for doing i18n translations packaged as an engine for Rails applications.'
  s.license = 'MIT'

  s.authors = ['David Heinemeier Hansson', 'Piotr Sarnacki', 'Emilio Tagua', 'Thomas Darde', 'Ferran Basora']
  s.email = 'david@loudthinking.com'
  s.homepage = 'http://github.com/tolk/tolk'

  s.platform = Gem::Platform::RUBY


  s.required_ruby_version = '>= 1.9.3'

  s.add_runtime_dependency 'rails', '>= 4.0', '< 4.2'
  s.add_runtime_dependency 'will_paginate'
  s.add_runtime_dependency 'safe_yaml', ">= 0.8.6"

  s.add_development_dependency 'capybara', '2.2.1'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'selenium-webdriver'


  if File.exists?('UPGRADING')
    s.post_install_message = File.read("UPGRADING")
  end

  s.files = Dir['README', 'MIT-LICENSE', 'config/routes.rb', 'init.rb', 'lib/**/*', 'app/**/*', 'public/tolk/**/*']

  s.require_path = 'lib'
end

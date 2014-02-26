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
  s.add_dependency('will_paginate')
  s.add_dependency('safe_yaml', "~> 0.8")
  if File.exists?('UPGRADING')
    s.post_install_message = File.read("UPGRADING")
  end

  s.files = Dir['README', 'MIT-LICENSE', 'config/routes.rb', 'init.rb', 'lib/**/*', 'app/**/*', 'public/tolk/**/*']

  s.require_path = 'lib'
end

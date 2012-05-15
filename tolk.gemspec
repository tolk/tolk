# encoding: utf-8
require File.expand_path('../lib/rails_admin/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'tolk'
  s.version     = Tolk::VERSION
  s.summary     = 'Rails engine providing web interface for managing i18n yaml files'
  s.description = 'Tolk is a web interface for doing i18n translations packaged as an engine for Rails applications.'

  s.author = ['David Heinemeier Hansson', 'Emilio Tagua', 'Thomas Darde']
  s.email = 'david@loudthinking.com'
  s.homepage = 'http://github.com/tolk/tolk'

  s.platform = Gem::Platform::RUBY
  s.add_dependency('will_paginate')
  s.add_dependency('ya2yaml', '~> 0.26')

  s.files = Dir['README', 'MIT-LICENSE', 'config/routes.rb', 'init.rb', 'lib/**/*', 'app/**/*', 'public/tolk/**/*']

  s.require_path = 'lib'
end

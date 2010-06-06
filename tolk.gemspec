Gem::Specification.new do |s|
  s.name        = 'tolk'
  s.version     = '1.0'
  s.summary     = 'Rails engine providing web interface for managing i18n yaml files'
  s.description = 'Tolk is a web interface for doing i18n translations packaged as an engine for Rails applications.'

  s.author = 'David Heinemeier Hansson'
  s.email = 'david@loudthinking.com'
  s.homepage = 'http://www.rubyonrails.org'

  s.platform = Gem::Platform::RUBY
  s.add_dependency('will_paginate', '3.0.pre')
  s.add_dependency('ya2yaml', '~> 0.26')

  s.files = Dir['README', 'MIT-LICENSE', 'config/routes.rb', 'init.rb', 'lib/**/*', 'app/**/*', 'public/tolk/**/*']
  s.has_rdoc = false

  s.require_path = 'lib'
end

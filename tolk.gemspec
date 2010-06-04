Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = 'tolk'
  s.version = '1.0'
  s.summary = 'Async ORM and controller layer.'
  s.description = 'Cramp provides ORM and controller layers for developing asynchronous web applications.'

  s.author = 'David Heinemeier Hansson'
  s.email = 'david@loudthinking.com'
  s.homepage = 'http://www.rubyonrails.org'

  s.add_dependency('activesupport', version)
  s.add_dependency('ya2yaml', version)

  s.files = Dir['README', 'MIT-LICENSE', 'config/routes.rb', 'init.rb', 'lib/**/*', 'app/**/*', 'public/tolk/**/*']
  s.has_rdoc = false

  s.require_path = 'lib'
end

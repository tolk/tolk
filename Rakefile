# encoding: UTF-8
require 'rake'
require 'rake/rdoctask'
require 'rake/gempackagetask'

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

task :default => :test

Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Tolk'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

spec = Gem::Specification.new do |s|
  s.name = "tolk"
  s.summary = "Rails engine providing web interface for managing i18n yaml files"
  s.description = "Tolk is a web interface for doing i18n translations packaged as an engine for Rails applications."
  s.files =  FileList["[A-Z]*", "lib/**/*"]
  s.version = "2.0.0.beta"
end

Rake::GemPackageTask.new(spec) do |pkg|
end

desc "Install the gem #{spec.name}-#{spec.version}.gem"
task :install do
  system("gem install pkg/#{spec.name}-#{spec.version}.gem --no-ri --no-rdoc")
end

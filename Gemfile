source "http://rubygems.org"

gemspec

gem "rails", ENV['RAILS_VERSION']

group 'development' do
  if RUBY_VERSION < '1.9'
    gem "ruby-debug", ">= 0.10.3"
  end
end

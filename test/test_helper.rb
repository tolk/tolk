# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require "capybara/rails"
require "mocha/minitest"
require "capybara/cuprite"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
# Would be nice to understand how to fix this, using duplicated fixtures for the moment...
# ActiveSupport::TestCase.fixture_paths << File.expand_path("../fixtures", __FILE__)

# Configure capybara for integration testing
Capybara.default_driver = :cuprite
Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(app, process_timeout: 20)
end

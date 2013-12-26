# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
#ActiveRecord::IdentityMap.enabled = false
require "rails/test_help"

ActiveSupport::TestCase.fixture_path = Rails.root.to_s + "/../fixtures"
ActiveSupport::TestCase.use_transactional_fixtures = true

ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options[:host] = "test.com"

Rails.backtrace_cleaner.remove_silencers!

# Configure capybara for integration testing
require "capybara/rails"
Capybara.default_driver   = :selenium
Capybara.default_selector = :css

# Run any available migrations
# A bit of hacks, find a nicer way
FileUtils.rm(Dir[File.expand_path("../dummy/db/test.sqlite3", __FILE__)])
FileUtils.rm(Dir[File.expand_path("../dummy/db/migrate/*.tolk.rb", __FILE__)])
ActiveRecord::Migration.copy File.expand_path("../dummy/db/migrate/", __FILE__), { :tolk => File.expand_path("../../db/migrate/", __FILE__) }
ActiveRecord::Migrator.migrate File.expand_path("../dummy/db/migrate/", __FILE__)

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

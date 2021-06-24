require 'rails/generators'
require File.expand_path('../utils', __FILE__)

module Tolk
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    include Rails::Generators::Migration

    argument :_namespace, type: :string, required: false, desc: "Tolk url namespace"
    desc "Tolk installation generator"
    def install
      #routes = File.open(Rails.root.join("config/routes.rb")).try :read
      #initializer = (File.open(Rails.root.join("config/initializers/tolk.rb")) rescue nil).try :read

      display "Adding a migration..."
      migration_template 'migration.rb', 'db/migrate/create_tolk_tables.rb' rescue puts $!.message

      # namespace = ask_for("Where do you want to mount tolk?", "tolk", _namespace)
      # gsub_file "config/routes.rb", /mount Tolk::Engine => \'\/.+\', as: \'tolk\'/, ''
      # gsub_file "config/routes.rb", /mount Tolk::Engine => \'\/.+\'/, ''
      # route("mount Tolk::Engine => '/#{namespace}', as: 'tolk'")

      puts "Completed. Start your server and visit '/#{namespace}'!"
    end
  end
end

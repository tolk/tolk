require 'rails/generators'
require File.expand_path('../utils', __FILE__)

# http://guides.rubyonrails.org/generators.html
# http://rdoc.info/github/wycats/thor/master/Thor/Actions.html
# keep generator idempotent, thanks
# Thanks to https://github.com/sferik/rails_admin !

module Tolk
  class InstallGenerator < Rails::Generators::Base

    source_root File.expand_path("../templates", __FILE__)
    include Rails::Generators::Migration
    include Generators::Utils::InstanceMethods
    extend Generators::Utils::ClassMethods

    argument :_namespace, :type => :string, :required => false, :desc => "Tolk url namespace"
    desc "Tolk installation generator"
    def install
      routes = File.open(Rails.root.join("config/routes.rb")).try :read
      initializer = (File.open(Rails.root.join("config/initializers/tolk.rb")) rescue nil).try :read

      display "Hello, Tolk installer will help you sets things up!", :black
      unless initializer
        install_generator = ask_boolean("Do you want to install the optional configuration file (to change mappings, locales dump location etc..) ?")
        template "initializer.erb", "config/initializers/tolk.rb" if install_generator
      else
        display "You already have a config file. You're updating, heh? I'm generating a new 'tolk.rb.example' that you can review."
        template "initializer.erb", "config/initializers/tolk.rb.example"
      end

      display "Adding a migration..."
      migration_template 'migration.rb', 'db/migrate/create_tolk_tables.rb' rescue display $!.message

      namespace = ask_for("Where do you want to mount tolk?", "tolk", _namespace)
      gsub_file "config/routes.rb", /mount Tolk::Engine => \'\/.+\', :as => \'tolk\'/, ''
      gsub_file "config/routes.rb", /mount Tolk::Engine => \'\/.+\'/, ''
      route("mount Tolk::Engine => '/#{namespace}', :as => 'tolk'")

      display "Job's done: migrate, start your server and visit '/#{namespace}'!", :blue

    end
  end
end
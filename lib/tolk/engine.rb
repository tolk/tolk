require 'rails'

module Tolk
  class Engine < Rails::Engine
    SafeYAML::OPTIONS[:default_mode] = :safe
    SafeYAML::OPTIONS[:deserialize_symbols] = true

    isolate_namespace Tolk

    initializer :assets do |app|
      app.config.assets.precompile += ['tolk/libraries.js']
    end
  end
end

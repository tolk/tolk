require 'rails'

module Tolk
  class Engine < Rails::Engine
    isolate_namespace Tolk

    initializer :assets do |app|
      app.config.assets.precompile += ['tolk/libraries.js']
    end
  end
end

require 'rails'

module Tolk
  class Engine < Rails::Engine
    SafeYAML::OPTIONS[:default_mode] = :safe
    SafeYAML::OPTIONS[:deserialize_symbols] = true

    isolate_namespace Tolk
  end
end

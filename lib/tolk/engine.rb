require 'rails'

module Tolk
  class Engine < Rails::Engine
    SafeYAML::OPTIONS[:default_mode] = :safe
    isolate_namespace Tolk
  end
end

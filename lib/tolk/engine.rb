require 'rails'

module Tolk
  class Engine < Rails::Engine
    isolate_namespace Tolk
  end
end

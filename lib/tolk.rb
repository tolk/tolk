require 'tolk/config'
require 'tolk/engine'
require 'tolk/sync'
require 'tolk/import'
require 'tolk/export'
require 'tolk/pagination'

module Tolk
  # Setup Tolk
  def self.config(&block)
    if block_given?
      block.call(Tolk::Config)
    else
      Tolk::Config
    end
  end
end

require 'will_paginate'
require 'safe_yaml/load'
require 'tolk/config'
require 'tolk/engine'
require 'tolk/sync'
require 'tolk/import'
require 'tolk/export'

module Tolk
  # Setup Tolk
  def self.config(&block)
    if block_given?
      block.call(Tolk::Config)
    else
      Tolk::Config
    end
  end

  SAFE_YAML_OPTIONS = SafeYAML::Deep.freeze({
    :default_mode => :safe,
    :deserialize_symbols => true
  })
end

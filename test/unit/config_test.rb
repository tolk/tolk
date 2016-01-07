require 'test_helper'
require 'fileutils'

class ConfigTest < ActiveSupport::TestCase
  test "config default values" do
    assert_equal Proc, Tolk.config.dump_path.class
    assert_equal "#{Rails.root}/config/locales", Tolk::Export.dump_path
    assert Tolk.config.mapping.keys.include?('ar')
    assert_equal 'Arabic',Tolk.config.mapping['ar']
    assert_equal true, Tolk.config.strip_texts
  end
end
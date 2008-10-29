require 'test_helper'

class SystemTest < ActiveSupport::TestCase
  test "dumping system as yml" do
    begin
      systems(:basecamp).location = RAILS_ROOT + "/tmp/"
      systems(:basecamp).dump
      assert_equal File.read(fixture_path + "/systems/basecamp-yml"), File.read(RAILS_ROOT + "/tmp/locales.yml")
    ensure
      File.delete(RAILS_ROOT + "/tmp/locales.yml")
    end
  end
end

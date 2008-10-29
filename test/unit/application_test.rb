require 'test_helper'

class ApplicationTest < ActiveSupport::TestCase
  test "dumping application as yml" do
    begin
      applications(:basecamp).location = RAILS_ROOT + "/tmp/"
      applications(:basecamp).dump
      assert_equal File.read(fixture_path + "/applications/basecamp-yml"), File.read(RAILS_ROOT + "/tmp/locales.yml")
    ensure
      File.delete(RAILS_ROOT + "/tmp/locales.yml")
    end
  end
end

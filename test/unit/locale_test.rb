require 'test_helper'

class LocaleTest < ActiveSupport::TestCase
  test "turning locale without nested phrases into a hash" do
    assert_equal({ "se" => { "hello_world" => "Hejsan Verdon" } }, locales(:se).to_hash)
  end
  
  test "turning locale with nested phrases into a hash" do
    assert_equal({ "en" => { 
      "hello_world" => "Hello World", 
      "nested" => { 
        "hello_world" => "Nested Hello World",
        "hello_country" => "Nested Hello Country"
      }
    }}, locales(:en).to_hash)
  end
  
  test "phrases without translations" do
    assert locales(:en).phrases_without_translation.include?(phrases(:cozy))
  end

  test "dumping all locales to yml" do
    begin
      FileUtils.mkdir_p(Rails.root + "/tmp/locales")
      Locale.dump_all(Rails.root + "/tmp/locales")
      
      %w( en da se ).each do |locale|
        assert_equal \
          File.read(fixture_path + "/locales/#{locale}-yml"), 
          File.read(RAILS_ROOT + "/tmp/locales/#{locale}.yml")
      end
    ensure
      FileUtils.rm_rf(Rails.root + "/tmp/locales")
    end
  end
end
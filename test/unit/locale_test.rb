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
    Tolk::Locale.primary_locale_name = 'en'

    begin
      FileUtils.mkdir_p(RAILS_ROOT + "/tmp/locales")
      Tolk::Locale.dump_all(RAILS_ROOT + "/tmp/locales")

      %w( da se ).each do |locale|
        assert_equal \
          File.read(RAILS_ROOT + "/test/locales/basic/#{locale}.yml"), 
          File.read(RAILS_ROOT + "/tmp/locales/#{locale}.yml")
      end

      # Make sure dump doesn't generate en.yml
      assert ! File.exists?(RAILS_ROOT + "/tmp/locales/en.yml")
    ensure
      FileUtils.rm_rf(RAILS_ROOT + "/tmp/locales")
    end
  end

  test "human language name" do
    assert_equal 'English', locales(:en).language_name
    assert_equal 'pirate', Tolk::Locale.new(:name => 'pirate').language_name
  end
end
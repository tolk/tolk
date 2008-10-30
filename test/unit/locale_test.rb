require 'test_helper'

class LocaleTest < ActiveSupport::TestCase
  test "turning locale without nested phrases into a hash" do
    assert_equal({ "hello_world" => "Hejsan Verdon" }, locales(:se).to_hash)
  end
  
  test "turning locale with nested phrases into a hash" do
    assert_equal({ 
      "hello_world" => "Hello World", 
      "nested" => { 
        "hello_world" => "Nested Hello World",
        "hello_country" => "Nested Hello Country"
      }
    }, locales("en-US").to_hash)
  end
  
  test "phrases without translations" do
    assert locales("en-US").phrases_without_translation.include?(phrases("phrase_not_translated_to_en-US"))
  end
end
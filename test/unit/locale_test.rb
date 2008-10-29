require 'test_helper'

class LocaleTest < ActiveSupport::TestCase
  test "turning locale without nested phrases into a hash" do
    assert_equal({ "hello_world" => "Hejsan Verdon" }, locales(:se).to_hash)
  end
  
  test "turning locale with nested phrases into a hash" do
    assert_equal({ "hello_world" => "Hello World", "nested" => { "hello_world" => "Nested Hello World" } }, locales("en-US").to_hash)
  end
end

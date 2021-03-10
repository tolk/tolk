require 'test_helper'

class LocaleTest < ActiveSupport::TestCase
  fixtures :all

  test "turning locale without nested phrases into a hash" do
    assert_equal({ "se" => { "hello_world" => "Hejsan Verdon" } }, tolk_locales(:se).to_hash)
  end

  test "turning locale with nested phrases into a hash" do
    assert_equal({ "en" => {
      "hello_world" => "Hello World",
      "nested" => {
        "hello_country" => "Nested Hello Country",
        "hello_world" => "Nested Hello World"
      },
      "number" => {
        "currency" => {
          "format" => {
            "significant" => false
          }
        },
        "human" => {
          "format" => {
            "precision" => "1"
          }
        }
      }
    }}, tolk_locales(:en).to_hash)
  end

  test "phrases without translations" do
    assert tolk_locales(:en).phrases_without_translation.include?(tolk_phrases(:cozy))
  end

  test "paginating phrases without translations" do
    Tolk::Phrase.paginates_per(2)
    locale = tolk_locales(:se)

    assert_equal [4, 3, 2, 6, 5], locale.phrases_without_translation.map(&:id)
  end

  test "paginating phrases with translations" do
    Tolk::Phrase.paginates_per(5)
    locale = tolk_locales(:en)

    assert_equal [1,2,3,5,6], locale.phrases.with_translation.map(&:id)
  end

  test "counting missing translations" do
    assert_equal 2, tolk_locales(:da).phrases_without_translation.count
    assert_equal 5, tolk_locales(:se).phrases_without_translation.count
  end

  test "dumping all locales to yml" do
    Tolk::Locale.primary_locale_name = 'en'
    Tolk::Locale.primary_locale(true)

    begin
      FileUtils.mkdir_p(Rails.root.join("../../tmp/locales"))
      Tolk::Locale.dump_all(Rails.root.join("../../tmp/locales"))

      %w( da se ).each do |locale|
        assert_equal \
          SafeYAML.load_file(Rails.root.join("../locales/basic/#{locale}.yml")),
          SafeYAML.load_file(Rails.root.join("../../tmp/locales/#{locale}.yml"))
      end

      # Make sure dump doesn't generate en.yml
      assert ! File.exist?(Rails.root.join("../../tmp/locales/en.yml"))
    ensure
      FileUtils.rm_rf(Rails.root.join("../../tmp/locales"))
    end
  end

  test "human language name" do
    assert_equal 'English', tolk_locales(:en).language_name
    assert_equal 'pirate', Tolk::Locale.new(name: 'pirate').language_name
  end

end

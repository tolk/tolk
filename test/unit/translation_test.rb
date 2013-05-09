require 'test_helper'
require 'fileutils'

class TranslationTest < ActiveSupport::TestCase
  fixtures :tolk_translations

  def setup
    Tolk::Locale.primary_locale(true)
  end

  test "translation is inavlid when a duplicate exists" do
    translation = Tolk::Translation.new(:phrase => tolk_translations(:hello_world_da).phrase, :locale => tolk_translations(:hello_world_da).locale)
    translation.text = "Revised Hello World"
    assert(translation.invalid?)
    assert(translation.errors[:phrase_id])
  end

  test "translation is not changed when text is assigned an equal value in numberic form" do
    translation = tolk_translations(:human_format_precision_en)
    assert_equal("1", translation.text)
    translation.text = "1"
    assert_equal(false, translation.changed?)
    translation.text = 1
    assert_equal(false, translation.changed?)
  end

  test "translation with string value" do
    assert_equal("Hello World", tolk_translations(:hello_world_en).value)
  end

  test "translation with string value with leading and trailing whitespace" do
    text = "\t          Hello World   \r\n"
    assert_equal(text.strip, Tolk::Translation.new(:text => text).value)
  end

  test "translation with string value with variables" do
    text = "{{attribute}} {{message}}"
    assert_equal(text, Tolk::Translation.new(:text => text).value)
  end

  test "translation with numeric value" do
    assert_equal(1, tolk_translations(:human_format_precision_en).value)
  end

  test "translation with true value" do
    assert_equal(true, tolk_translations(:number_currency_format_significant_da).value)
  end

  test "translation with false value" do
    assert_equal(false, tolk_translations(:number_currency_format_significant_en).value)
  end

  test "translation with hash value" do
    hash = {:foo => "bar"}
    assert_equal(hash, Tolk::Translation.new(:text => hash).value)
  end

  test "pluralization translation special variable 'count' not a variable" do
    text = {
      'zero' => "{{message}}",
      'many' => "{{message}} {{count}}",
      'other' => "{{message}} {{count}}"
    }
    assert_equal(Set['message'], Tolk::Translation.detect_variables(text))
  end

  test "validation for variables (mismatch)" do
    primary_text = {
      'zero' => "{{message}}",
      'many' => "{{message}} {{count}}",
    }
    text = {
      'zero' => "{{message}}",
      'many' => "{{foo}}",
    }

    Tolk::Translation.new(:text => text).tap do |t|
      t.stubs(:primary_translation).returns(Tolk::Translation.new(:text => primary_text))
      t.valid?
      assert_equal ["The translation should contain the substitutions of the primary translation: (message), found (message, foo)."], t.errors[:variables]
    end
  end

  test "validation for variables (no variables in primary)" do
    primary_text = {
      'foo' => "nada"
    }
    text = {
      'foo' => "{{foo}} nada"
    }

    Tolk::Translation.new(:text => text).tap do |t|
      t.stubs(:primary_translation).returns(Tolk::Translation.new(:text => primary_text))
      t.valid?
      assert_equal ["The primary translation does not contain substitutions, so this should neither."], t.errors[:variables]
    end
  end
end

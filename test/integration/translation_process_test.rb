require 'test_helper'

class TranslationProcessTest < ActiveSupport::IntegrationCase
  setup :setup_locales

  def test_adding_locale
    assert_difference('Tolk::Locale.count') { add_locale 'German' }
  end

  def test_adding_missing_translations_and_updating_translations
    Tolk.config.mapping['xx'] = "Pirate"

    locale = add_locale("Pirate")
    assert locale.translations.empty?

    # Adding a new translation
    pirate_path = tolk.locale_path(locale)
    visit pirate_path

    fill_in_first_translation :with => "Dead men don't bite"
    click_button 'Save changes'

    assert_equal current_path, pirate_path
    assert_equal 1, locale.translations.count

    # Updating the translation added above
    click_link 'See completed translations'
    assert page.has_text?(:all, "Dead men don't bite")

    fill_in_first_translation :with => "Arrrr!"
    click_button 'Save changes'

    assert_equal current_path, tolk.all_locale_path(locale)
    assert_equal 1, locale.translations.count
    assert_equal 'Arrrr!', locale.translations.reload.first.text
  end

  def test_search_phrase_within_key
    Tolk.config.mapping['xx'] = "Pirate"
    locale = add_locale("Pirate")
    assert locale.translations.empty?

    # Adding a new translation
    pirate_path = tolk.locale_path(locale)
    visit pirate_path

    fill_in 'q', :with => 'hello_country'
    fill_in 'k', :with => 'nested'

    click_button 'Search'
    assert_equal true, page.has_selector?('td.translation', :count => 1)
  end

  private

  def fill_in_first_translation(with_hash)
    within(:xpath, '//table[@class = "translations"]//tr[2]/td[@class = "translation"][1]') do
      fill_in 'translations[][text]', with_hash
    end

  end

  def add_locale(name)
    visit tolk.root_path
    select name, :from => "select_tolk_locale_name"
    click_button 'Add'

    Tolk::Locale.where(name: Tolk.config.mapping.key(name)).first!
  end

  def setup_locales
    Tolk::Locale.delete_all
    Tolk::Translation.delete_all
    Tolk::Phrase.delete_all

    Tolk::Locale.locales_config_path = File.join(Rails.root, "../locales/sync/")

    I18n.backend.reload!
    I18n.load_path = [Tolk::Locale.locales_config_path + 'en.yml']
    I18n.backend.send :init_translations

    Tolk::Locale.primary_locale(true)

    Tolk::Locale.sync!
  end
end

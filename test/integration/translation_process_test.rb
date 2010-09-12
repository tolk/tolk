require 'test_helper'

class TranslationProcessTest < ActiveSupport::IntegrationCase
  setup :setup_locales

  def test_adding_locale
    assert_difference('Tolk::Locale.count') { add_locale 'German' }
  end

  def test_adding_missing_translations_and_updating_translations
    Tolk::Locale::MAPPING['xx'] = "Pirate"
    
    locale = add_locale("Pirate")
    assert locale.translations.empty?

    # Adding a new translation
    pirate_path = tolk.locale_path(locale)
    visit pirate_path
    fill_in 'translations[][text]', :with => "Dead men don't bite"
    click_button 'Save changes'

    assert_equal current_path, pirate_path
    assert_equal 1, locale.translations.count

    # Updating the translation added above
    click_link 'See completed translations'
    assert page.has_content?("Dead men don't bite")

    fill_in 'translations[][text]', :with => "Arrrr!"
    click_button 'Save changes'

    assert_equal current_path, tolk.all_locale_path(locale)
    assert_equal 1, locale.translations.count
    assert_equal 'Arrrr!', locale.translations(true).first.text
  end

  private

  def add_locale(name)
    visit tolk.root_path
    select name, :from => "select_tolk_locale_name"
    click_button 'Add'

    Tolk::Locale.find_by_name!(Tolk::Locale::MAPPING.index(name))
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

require 'test_helper'
require 'fileutils'

class ImportTest < ActiveSupport::TestCase
  def setup
    Tolk::Locale.delete_all
    Tolk::Translation.delete_all
    Tolk::Phrase.delete_all

    Tolk::Locale.locales_config_path = Rails.root.join("../locales/import/")

    I18n.backend.reload!
    I18n.load_path = [Tolk::Locale.locales_config_path + 'en.yml']
    I18n.backend.send :init_translations

    Tolk::Locale.primary_locale(true)
  end

  test "skips gem translations files (xxx.en.yml)" do
    Tolk::Locale.sync!
    Tolk::Locale.import_secondary_locales
    

    assert_equal 0, Tolk::Phrase.where(key: 'gem_hello_world').count
    
  end
  
end
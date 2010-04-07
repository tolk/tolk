require 'test_helper'
require 'fileutils'

class SyncTest < ActiveSupport::TestCase
  def setup
    Locale.delete_all
    Translation.delete_all
    Phrase.delete_all

    Locale.locales_config_path = RAILS_ROOT + "/test/locales/sync"
    Locale.primary_locale_name = 'en'
  end

  def test_flat_hash
    data = {'home' => {'hello' => 'hola', 'sidebar' => {'title' => 'something'}}}
    result = Locale.send(:flat_hash, data)

    assert_equal 2, result.keys.size
    assert_equal ['home.hello', 'home.sidebar.title'], result.keys.sort
    assert_equal ['hola', 'something'], result.values.sort
  end

  def test_sync_creates_locale_phrases_translations
    Locale.sync!

    # Created by sync!
    primary_locale = Locale.find_by_name!(Locale.primary_locale_name)

    assert_equal ["Hello World", "Nested Hello Country"], primary_locale.translations.map(&:text).sort
    assert_equal ["hello_world", "nested.hello_country"], Phrase.all.map(&:key).sort
  end

  def test_sync_deletes_stale_translations_for_secondary_locales_on_delete_all
    spanish = Locale.create!(:name => 'es')

    Locale.sync!

    phrase = Phrase.all.detect {|p| p.key == 'hello_world'}
    hola = spanish.translations.create!(:text => 'hola', :phrase => phrase)

    # Mimic deleting all the translations
    Locale.expects(:read_primary_locale_file).returns({})
    Locale.sync!

    assert_equal 0, Phrase.count
    assert_equal 0, Translation.count

    assert_raises(ActiveRecord::RecordNotFound) { hola.reload }
  end

  def test_sync_deletes_stale_translations_for_secondary_locales_on_delete_some
    spanish = Locale.create!(:name => 'es')

    Locale.sync!

    phrase = Phrase.all.detect {|p| p.key == 'hello_world'}
    hola = spanish.translations.create!(:text => 'hola', :phrase => phrase)

    # Mimic deleting 'hello_world'
    Locale.expects(:read_primary_locale_file).returns({'nested.hello_country' => 'Nested Hello World'})
    Locale.sync!

    assert_equal 1, Phrase.count
    assert_equal 1, Translation.count
    assert_equal 0, spanish.translations.count

    assert_raises(ActiveRecord::RecordNotFound) { hola.reload }
  end

  def test_sync_handles_deleted_keys_and_updated_translations
    Locale.sync!

    # Mimic deleting 'nested.hello_country' and updating 'hello_world'
    Locale.expects(:read_primary_locale_file).returns({"hello_world" => "Hello Super World"})
    Locale.sync!

    primary_locale = Locale.find_by_name!(Locale.primary_locale_name)

    assert_equal ['Hello Super World'], primary_locale.translations.map(&:text)
    assert_equal ['hello_world'], Phrase.all.map(&:key).sort
  end

  def test_sync_doesnt_mess_with_existing_translations
    spanish = Locale.create!(:name => 'es')

    Locale.sync!

    phrase = Phrase.all.detect {|p| p.key == 'hello_world'}
    hola = spanish.translations.create!(:text => 'hola', :phrase => phrase)

    # Mimic deleting 'nested.hello_country' and updating 'hello_world'
    Locale.expects(:read_primary_locale_file).returns({"hello_world" => "Hello Super World"})
    Locale.sync!

    hola.reload
    assert_equal 'hola', hola.text
  end

  def test_dump_all_after_sync
    spanish = Locale.create!(:name => 'es')

    Locale.sync!

    phrase = Phrase.all.detect {|p| p.key == 'hello_world'}
    hola = spanish.translations.create!(:text => 'hola', :phrase => phrase)

    tmpdir = RAILS_ROOT + "/tmp/sync/locales"
    FileUtils.mkdir_p(tmpdir)
    Locale.dump_all(tmpdir)

    spanish_file = "#{tmpdir}/es.yml"
    data = YAML::load(IO.read(spanish_file))['es']
    assert_equal ['hello_world'], data.keys
    assert_equal 'hola', data['hello_world']
  ensure
    FileUtils.rm_f(tmpdir)
  end
end
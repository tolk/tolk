class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  fixtures :all

  self.fixture_class_names = {:tolk_locales => 'Tolk::Locale', :tolk_phrases => 'Tolk::Phrase', :tolk_translations => 'Tolk::Translation'}
end

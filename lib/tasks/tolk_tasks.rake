namespace :tolk do
  desc "Sync Tolk with the default locale's yml file"
  task :sync => :environment do
    Tolk::Locale.sync!
  end

  desc "Generate yml files for all the locales defined in Tolk"
  task :dump_all => :environment do
    Tolk::Locale.dump_all
  end

  desc "Imports data all non default locale yml files to Tolk"
  task :import => :environment do
    Rake::Task['tolk:sync'].invoke
    Tolk::Locale.import_secondary_locales
  end

  desc "Show all the keys potentially containing HTML values and no _html postfix"
  task :html_keys => :environment do
    bad_translations = Tolk::Locale.primary_locale.translations_with_html
    bad_translations.each do |bt|
      puts "#{bt.phrase.key} - #{bt.text}"
    end
  end

  desc "Copies required assets from tolk to application's public/ directory"
  task :import_assets do
    tolk_assets = File.expand_path(File.join(File.dirname(__FILE__), '../../public/tolk'))
    command = "cp -R #{tolk_assets} #{Rails.root}/public/"
    puts command
    system(command)
  end

end

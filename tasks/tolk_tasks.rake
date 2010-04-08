namespace :tolk do
  desc "Sync Tolk with the default locale's yml file"
  task :sync => :environment do
    Tolk::Locale.sync!
  end

  desc "Generate yml files for all the locales defined in Tolk"
  task :dump_all => :environment do
    Tolk::Locale.dump_all
  end
end

["sqlite3"].each do |db_gem|

  appraise "rails_7.0.#{db_gem}" do
    gem "rails", "~> 7.0.2"
    gem "sqlite3", "~> 2.0"
    gem db_gem
  end

  appraise "rails_7.1.#{db_gem}" do
    gem "rails", "~> 7.1.0"
    gem "sqlite3", "~> 2.0"
    gem db_gem
  end

end

class CreateTolkTables < ActiveRecord::Migration
  def self.up
    create_table :locales do |t|
      t.string   :name
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :phrases do |t|
      t.text     :key
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :translations do |t|
      t.integer  :phrase_id
      t.integer  :locale_id
      t.text     :text
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :translations
    drop_table :phrases
    drop_table :locales
  end
end

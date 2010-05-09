class AddMissingIndices < ActiveRecord::Migration
  def self.up
    add_index :tolk_locales, :name, :unique => true
    add_index :tolk_translations, [:phrase_id, :locale_id], :unique => true
  end

  def self.down
    remove_index :tolk_translations, :column => [:phrase_id, :locale_id]
    remove_index :tolk_locales, :column => :name
  end
end

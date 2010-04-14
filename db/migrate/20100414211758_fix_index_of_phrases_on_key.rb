class FixIndexOfPhrasesOnKey < ActiveRecord::Migration
  def self.up
    remove_index :tolk_phrases, :column => :key
        
    add_index :tolk_phrases, :key
  end

  def self.down
    remove_index :tolk_phrases, :key
    
    add_index :tolk_phrases, :key, :unique => true
  end
end

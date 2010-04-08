class AddUpdatedStuff < ActiveRecord::Migration
  def self.up
    add_column :translations, :updated, :boolean, :default => false
    add_column :translations, :previous_text, :text
  end

  def self.down
    remove_column :translations, :previous_text
    remove_column :translations, :updated
  end
end

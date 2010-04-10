module Tolk
  class Translation < ActiveRecord::Base
    set_table_name "tolk_translations"

    serialize :text

    validates_uniqueness_of :phrase_id, :scope => :locale_id

    belongs_to :phrase, :class_name => 'Tolk::Phrase'
    belongs_to :locale, :class_name => 'Tolk::Locale'

    attr_accessor :force_set_primary_update
    before_save :set_primary_updated

    before_save :set_previous_text

    before_validation :fix_text_type

    private

    def fix_text_type
      if self.text && self.text.is_a?(String)
        yaml_object = begin
          YAML.load(self.text.strip)
        rescue ArgumentError
          self.text
        end

        self.text = yaml_object unless yaml_object.is_a?(String)
      end

      true
    end

    def set_primary_updated
      self.primary_updated = self.force_set_primary_update ? true : false
      true
    end

    def set_previous_text
      self.previous_text = self.text_was if text_changed?
      true
    end

  end
end

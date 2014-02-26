module Tolk
  class Translation < ActiveRecord::Base
    self.table_name = "tolk_translations"

    scope :containing_text, lambda {|query| where("tolk_translations.text LIKE ?", "%#{query}%") }

    serialize :text
    serialize :previous_text
    validate :validate_text_not_nil, :if => proc {|r| r.primary.blank? && !r.explicit_nil && !r.boolean?}
    validate :check_matching_variables, :if => proc { |tr| tr.primary_translation.present? }

    validates_uniqueness_of :phrase_id, :scope => :locale_id

    belongs_to :phrase, :class_name => 'Tolk::Phrase'
    belongs_to :locale, :class_name => 'Tolk::Locale'
    validates_presence_of :locale_id

    before_save :set_primary_updated

    before_save :set_previous_text

    attr_accessor :primary
    before_validation :fix_text_type, :unless => proc {|r| r.primary }

    attr_accessor :explicit_nil
    before_validation :set_explicit_nil

    def boolean?
      text.is_a?(TrueClass) || text.is_a?(FalseClass) || text == 't' || text == 'f'
    end

    def up_to_date?
      not out_of_date?
    end

    def out_of_date?
      primary_updated?
    end

    def primary_translation
      @_primary_translation ||= begin
        if locale && !locale.primary?
          phrase.translations.primary
        end
      end
    end

    def text=(value)
      value = value.to_s if value.kind_of?(Fixnum)
      if primary_translation && primary_translation.boolean?
        value = case value.to_s.downcase.strip
        when 'true', 't'
          true
        when 'false', 'f'
          false
        else
          self.explicit_nil = true
          nil
        end
        super unless value == text
      else
        value = value.strip if value.is_a?(String)
        super unless value.to_s == text
      end
    end

    def value
      if text.is_a?(String) && /^\d+$/.match(text)
        text.to_i
      elsif (primary_translation || self).boolean?
        %w[true t].member?(text.to_s.downcase.strip)
      else
        text
      end
    end

    def self.detect_variables(search_in)
      variables = case search_in
        when String then Set.new(search_in.scan(/\{\{(\w+)\}\}/).flatten + search_in.scan(/\%\{(\w+)\}/).flatten)
        when Array then search_in.inject(Set[]) { |carry, item| carry + detect_variables(item) }
        when Hash then search_in.values.inject(Set[]) { |carry, item| carry + detect_variables(item) }
        else Set[]
      end

      # delete special i18n variable used for pluralization itself (might not be used in all values of
      # the pluralization keys, but is essential to use pluralization at all)
      if search_in.is_a?(Hash) && Tolk::Locale.pluralization_data?(search_in)
        variables.delete_if {|v| v == 'count' }
      else
        variables
      end
    end

    def variables
      self.class.detect_variables(text)
    end

    def variables_match?
      self.variables == primary_translation.variables
    end

    private

    def set_explicit_nil
      if self.text == '~'
        self.text = nil
        self.explicit_nil = true
      end
    end

    def fix_text_type
      if primary_translation.present?
        if self.text.is_a?(String) && !primary_translation.text.is_a?(String)
          self.text = begin
            YAML.safe_load(self.text.strip)
          rescue ArgumentError
            nil
          end
        end

        if primary_translation.boolean?
          self.text = case self.text.to_s.strip
          when 'true'
            true
          when 'false'
            false
          else
            nil
          end
        elsif primary_translation.text.class != self.text.class
          self.text = nil
        end
      end

      true
    end

    def set_primary_updated
      self.primary_updated = false
      true
    end

    def set_previous_text
      self.previous_text = self.text_was if text_changed?
      true
    end

    def check_matching_variables
      unless variables_match?
        if primary_translation.variables.empty?
          self.errors.add(:variables, "The primary translation does not contain substitutions, so this should neither.")
        else
          self.errors.add(:variables, "The translation should contain the substitutions of the primary translation: (#{primary_translation.variables.to_a.join(', ')}), found (#{self.variables.to_a.join(', ')}).")
        end
      end
    end

    def validate_text_not_nil
      return unless text.nil?
      errors.add :text, :blank
    end
  end
end

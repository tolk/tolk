module Tolk
  class Translation < ActiveRecord::Base
    self.table_name = "tolk_translations"

    if defined?(ProtectedAttributes)
      attr_accessible :id, :phrase_id, :locale_id, :text
    end

    attr_accessor :primary, :explicit_nil

    serialize :text
    serialize :previous_text

    belongs_to :phrase, class_name: 'Tolk::Phrase'
    belongs_to :locale, class_name: 'Tolk::Locale'

    validates :locale_id, presence: true
    validates :phrase_id, uniqueness: {scope: :locale_id}
    #validates :text, presence: true, if: proc {|r| r.primary.blank? && !r.explicit_nil && !r.boolean?}
    validate :check_matching_variables, if: proc { |tr| tr.primary_translation.present? }

    before_validation :fix_text_type, unless: proc {|r| r.primary }
    before_validation :set_explicit_nil
    before_save :set_primary_updated
    before_save :set_previous_text

    scope :containing_text, lambda {|query| where("tolk_translations.text LIKE ?", "%#{query}%") }

    def boolean?
      [true, false, "t", "f"].include?(text)
    end

    def out_of_date?
      primary_updated?
    end

    def up_to_date?
      !out_of_date?
    end

    def primary_translation
      @_primary_translation ||= begin
        if locale && !locale.primary?
          phrase.translations.primary
        end
      end
    end

    def text=(value)
      if value.kind_of?(Integer)
        value = value.to_s
      end

      if primary_translation && primary_translation.boolean?
        case value.to_s.downcase.strip
        when 'true', 't'
          value = true
        when 'false', 'f'
          value = false
        else
          self.explicit_nil = true
          value = nil
        end
      else
        if value.is_a?(String) && Tolk.config.strip_texts
          value = value.strip
        end
      end

      if value != text
        super
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
      case search_in
      when String 
        variables = Set.new(search_in.scan(/\{\{(\w+)\}\}/).flatten + search_in.scan(/\%\{(\w+)\}/).flatten)
      when Array 
        variables = search_in.inject(Set[]) { |carry, item| carry + detect_variables(item) }
      when Hash 
        variables = search_in.values.inject(Set[]) { |carry, item| carry + detect_variables(item) }
      else 
        variables = Set[]
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
          begin
            self.text = YAML.load(self.text.strip)
          rescue ArgumentError
            self.text = nil
          end
        end

        if primary_translation.boolean?
          case self.text.to_s.strip
          when 'true'
            self.text = true
          when 'false'
            self.text = false
          else
            self.text = nil
          end
        elsif primary_translation.text.class != self.text.class
          self.text = nil
        end
      end
    end

    def set_primary_updated
      self.primary_updated = false
    end

    def set_previous_text
      if text_changed?
        self.previous_text = self.text_was
      end
    end

    def check_matching_variables
      if !variables_match?
        if primary_translation.variables.empty?
          self.errors.add(:variables, "The primary translation does not contain substitutions, so this should neither.")
        else
          #self.errors.add(:variables, "The translation should contain the substitutions of the primary translation: (#{primary_translation.variables.to_a.join(', ')}), found (#{self.variables.to_a.join(', ')}).")
          ### NEW: DO NOTHING
        end
      end
    end
  end
end

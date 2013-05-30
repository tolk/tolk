module Tolk
  module ApplicationHelper
    def format_i18n_value(value)
      value = h(yaml_value(value))
      value = highlight_linebreaks(value)
      value = highligh_interpolations(value)
    end

    def highlight_linebreaks(value)
      value.gsub(/\n/, '<span class="carriage_return" title="Line break"><br /></span>').html_safe
    end

    def highligh_interpolations(value)
      value.gsub(/%{\w+}/, '<span class="interpolation" title="Leave this word untranslated">\0</span>').html_safe
    end

    def format_i18n_text_area_value(value)
      yaml_value(value).to_s.force_encoding("UTF-8")
    end

    def yaml_value(value)
      if value.present?
        unless value.is_a?(String) || value.is_a?(TrueClass) || value.is_a?(FalseClass)
          value = value.respond_to?(:ya2yaml) ? value.ya2yaml(:syck_compatible => true) : value.to_yaml
        end
      end

      value
    end

    def boolean_warning
      '<span class="boolean">(Do not translate -- Enter true or false)</span>'.html_safe
    end

    def tolk_locale_selection
      existing_locale_names = Tolk::Locale.all.map(&:name)

      pairs = Tolk.config.mapping.to_a.map(&:reverse).sort_by(&:first)
      pairs.reject {|pair| existing_locale_names.include?(pair.last) }
    end

    def scope_selector_for(locale)
      select_tag 'scope', options_for_select([[Tolk::Locale.primary_locale.language_name, "origin"],
                                              [locale.language_name, "target"]], params[:scope])
    end
  end
end

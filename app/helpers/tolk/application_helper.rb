module Tolk
  module ApplicationHelper
    def format_i18n_value(value)
      unless value.is_a?(String)
        value = value.respond_to?(:ya2yaml) ? value.ya2yaml : value.to_yaml
      end

      h(value).gsub(/\n/, '<br />')
    end

    def format_i18n_text_area_value(value)
      unless value.is_a?(String)
        value = value.respond_to?(:ya2yaml) ? value.ya2yaml : value.to_yaml
      end

      value
    end

  end
end

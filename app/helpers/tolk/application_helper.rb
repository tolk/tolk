module Tolk
  module ApplicationHelper
    def format_i18n_value(value)
      h(yaml_value(value)).gsub(/\n/, '<br />')
    end

    def format_i18n_text_area_value(value)
      yaml_value(value)
    end

    def yaml_value(value)
      unless value.is_a?(String)
        value = value.respond_to?(:ya2yaml) ? value.ya2yaml(:syck_compatible => true) : value.to_yaml
      end

      value
    end

  end
end

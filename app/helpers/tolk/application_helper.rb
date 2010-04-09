module Tolk
  module ApplicationHelper
    def format_i18n_value(value)
      value = value.to_yaml unless value.is_a?(String)
      h(value).gsub(/\n/, '<br />')
    end

    def format_i18n_text_area_value(value)
      value = value.to_yaml unless value.is_a?(String)
      value
    end
  end
end

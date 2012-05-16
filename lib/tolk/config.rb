require 'active_support/core_ext/class/attribute_accessors'

module Tolk
  module Config


    class << self
      # Application title, can be an array of two elements
      attr_accessor :mapping
      
      def reset
        @mapping = {
          'ar'    => 'Arabic',
          'bs'    => 'Bosnian',
          'bt'    => 'Bulgarian',
          'ca'    => 'Catalan',
          'cz'    => 'Czech',
          'da'    => 'Danish',
          'de'    => 'German',
          'dsb'   => 'Lower Sorbian',
          'el'    => 'Greek',
          'en'    => 'English',
          'es'    => 'Spanish',
          'et'    => 'Estonian',
          'fa'    => 'Persian',
          'fi'    => 'Finnish',
          'fr'    => 'French',
          'he'    => 'Hebrew',
          'hr'    => 'Croatian',
          'hsb'   => 'Upper Sorbian',
          'hu'    => 'Hungarian',
          'id'    => 'Indonesian',
          'is'    => 'Icelandic',
          'it'    => 'Italian',
          'jp'    => 'Japanese',
          'ko'    => 'Korean',
          'lo'    => 'Lao',
          'lt'    => 'Lithuanian',
          'lv'    => 'Latvian',
          'mk'    => 'Macedonian',
          'nl'    => 'Dutch',
          'no'    => 'Norwegian',
          'pl'    => 'Polish',
          'pt-br' => 'Portuguese (Brazilian)',
          'pt-PT' => 'Portuguese (Portugal)',
          'ro'    => 'Romanian',
          'ru'    => 'Russian',
          'se'    => 'Swedish',
          'sk'    => 'Slovak',
          'sl'    => 'Slovenian',
          'sr'    => 'Serbian',
          'sw'    => 'Swahili',
          'th'    => 'Thai',
          'tr'    => 'Turkish',
          'uk'    => 'Ukrainian',
          'vi'    => 'Vietnamese',
          'zh-CN' => 'Chinese (Simplified)',
          'zh-TW' => 'Chinese (Traditional)'
        }
      end
    end

    # Set default values for configuration options on load
    self.reset
  end
end
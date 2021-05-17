require 'active_support/core_ext/class/attribute_accessors'

module Tolk
  module Config


    class << self
      # Mapping : a hash of the type { 'ar'    => 'Arabic' }
      attr_accessor :mapping

      # Dump locale path by default the locales folder (config/locales)
      attr_accessor :dump_path

      # primary locale to not be overriden by default locale in development mode
      attr_accessor :primary_locale_name

      # exclude locales tokens from gems
      attr_accessor :exclude_gems_token

      # reject files of type xxx.en.yml when syncing locales
      attr_accessor :block_xxx_en_yml_locale_files

      # strip translation texts automatically
      attr_accessor :strip_texts

      # specify line width which Yaml.dump will use to break lines. -1 for not breaking
      attr_accessor :yaml_line_width

      # specify controller to inherit from to keep Tolk controllers
      # in the same context than the rest of your app
      attr_accessor :base_controller

      # Ignore specific keys
      attr_accessor :ignore_keys

      # Google Cloud Platform project ID for translation
      attr_accessor :translate_project_id

      # Google Cloud Platfrom location ID for translation
      attr_accessor :translate_location_id

      # Google Cloud Platfrom path to auth JSON
      attr_accessor :translate_auth_json_location

      def reset
        @exclude_gems_token = false

        @strip_texts = true

        @block_xxx_en_yml_locale_files = true # keep compat with older versions

        @dump_path = Proc.new { "#{Rails.application.root}/config/locales" }

        @mapping = {
          'ar'    => 'Arabic',
          'bs'    => 'Bosnian',
          'bg'    => 'Bulgarian',
          'ca'    => 'Catalan',
          'cs'    => 'Czech',
          'da'    => 'Danish',
          'de'    => 'German',
          'el'    => 'Greek',
          'en'    => 'English',
          'es'    => 'Spanish',
          'et'    => 'Estonian',
          'fa'    => 'Persian',
          'fi'    => 'Finnish',
          'fr'    => 'French',
          'he'    => 'Hebrew',
          'hr'    => 'Croatian',
          'hu'    => 'Hungarian',
          'id'    => 'Indonesian',
          'is'    => 'Icelandic',
          'it'    => 'Italian',
          'ja'    => 'Japanese',
          'ko'    => 'Korean',
          'lo'    => 'Lao',
          'lt'    => 'Lithuanian',
          'lv'    => 'Latvian',
          'mk'    => 'Macedonian',
          'nl'    => 'Dutch',
          'no'    => 'Norwegian',
          'pl'    => 'Polish',
          'pt-BR' => 'Portuguese (Brazilian)',
          'pt-PT' => 'Portuguese (Portugal)',
          'ro'    => 'Romanian',
          'ru'    => 'Russian',
          'sv'    => 'Swedish',
          'sk'    => 'Slovak',
          'sl'    => 'Slovene',
          'sr'    => 'Serbian',
          'sw'    => 'Swahili',
          'th'    => 'Thai',
          'tr'    => 'Turkish',
          'uk'    => 'Ukrainian',
          'vi'    => 'Vietnamese',
          'zh-CN' => 'Chinese (Simplified)',
          'zh-TW' => 'Chinese (Traditional)'
        }

        @yaml_line_width = Psych::Handler::OPTIONS.line_width # Psych::Handler::DumperOptions uses 0 as "default" for unset

        @base_controller =  'ActionController::Base'

        @ignore_keys = []
      end
    end

    # Set default values for configuration options on load
    self.reset
  end
end

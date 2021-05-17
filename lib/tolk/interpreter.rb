require 'google/cloud/translate'


module Tolk
  class Interpreter

    INTERPOLATION_DETECTION = /(%\{[a-zA-Z0-9_\-]*\})/

    def initialize
      puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>> INIT <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
      ENV['TRANSLATE_CREDENTIALS'] = Tolk::Config.translate_auth_json_location

      project_id = Tolk::Config.translate_project_id
      location_id = Tolk::Config.translate_location_id

      @client = Google::Cloud::Translate.new
      @parent = @client.class.location_path project_id, location_id
    end

    def prepare_text(original_text)
      # when interpolation is used it will be wrapped into span for skipping translation
      original_text.gsub(INTERPOLATION_DETECTION, "<span class='notranslate'>\\1</span>")
    end

    def clean_text(translated_text)
      return translated_text unless translated_text.match(INTERPOLATION_DETECTION)

      # remove span for skipping translation before persisting translation
      translated_text.gsub(/\<span class='notranslate'\>([a-zA-Z0-9_\-%\{\}]*)\<\/span\>/, '\1')
    end

    def start_translation(locale)
      phrases = locale.phrases_without_translation().per(40)
      for_translation = []

      phrases.each do |phrase|
        primary_text = phrase.translations.primary.text


        if primary_text.is_a?(Hash)
          # hashes will be saved as translation due to complexity that they bring and are rarely used
          phrase.translations.create(text: primary_text, locale_id: locale.id)
          ap "HASH SAVED!!!"
          next
        end

        if primary_text.is_a?(Array)
          content = primary_text.compact.collect { |text| prepare_text(text) }

          # special case when we have that is saved as translation
          response = @client.translate_text content, locale.name, @parent, source_language_code: Tolk::Locale.primary_locale_name

          translated_text = response.translations.collect { |obj| clean_text(obj.translated_text) }

          # we send seperate API call for this, and save results
          phrase.translations.create(text: translated_text, locale_id: locale.id)

          ap content
          ap translated_text
          ap ">>>>>>>>>>>>>>> ARRAY >>>>>>>>>"

          next
        end

        text = phrase.translations.primary.text

        if text.nil?
          Rails.logger.info("Unable to translate pharase  ID: #{phrase.id}")
          next
        end

        for_translation << prepare_text(text)
      end


      #  TODO: Add response
      return if for_translation.empty?
      
      response = @client.translate_text for_translation, locale.name, @parent, source_language_code: Tolk::Locale.primary_locale_name
      translations = []
      response.translations.each_with_index do |object, index|
        translations << {
          text: clean_text(object.translated_text),
          locale_id: locale.id,
          phrase_id: phrases[index].id
        }

        ap for_translation[index]
        ap clean_text(object.translated_text)
        ap ">>>>>>>>>>>>>>>>>>>>>>>>"
      end



      locale.translations_attributes = translations
      locale.save
    end
  end
end
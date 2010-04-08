module Tolk
  class TranslationsController < ApplicationController
    before_filter :find_locale
    before_filter :ensure_no_primary_locale

    def create
      @translation = @locale.translations.new(params[:tolk_translation])

      if @translation.save
        flash[:notice] = 'Translation saved'
      else
        flash[:alert] = 'Translation could not be saved'
      end

      redirect_to @locale
    end

    def update
      @translation = @locale.translations.find(params[:id])
      @translation.update_attributes!(params[:tolk_translation])
      head :ok
    end

    private

    def find_locale
      locale_id = params[:tolk_translation].delete(:locale_id) if params[:tolk_translation]
      @locale = Tolk::Locale.find(locale_id)
    end
  end
end

module Tolk
  class LocalesController < ApplicationController
    before_filter :find_locale, :only => [:show, :all, :update]
    before_filter :ensure_no_primary_locale, :only => [:all, :update]

    def index
      @locales = Tolk::Locale.secondary_locales
    end
  
    def show
      if @locale.primary?
        render :primary_locale 
      else
        @phrases = @locale.phrases_without_translation(params[:page])
      end
    end

    def update
      @locale.translations_attributes = params[:translations]
      @locale.save!
      redirect_to request.referrer
    end

    def all
      @phrases = @locale.phrases_with_translation(params[:page])
    end

    def create
      Tolk::Locale.create!(params[:tolk_locale])
      redirect_to :action => :index
    end

    private

    def find_locale
      @locale = Tolk::Locale.find_by_name!(params[:id])
    end
  end
end

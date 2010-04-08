module Tolk
  class LocalesController < ApplicationController
    before_filter :find_locale, :only => [:show, :all, :update]
    before_filter :ensure_no_primary_locale, :only => [:all, :update, :show]

    def index
      @locales = Tolk::Locale.secondary_locales
    end
  
    def show
      respond_to do |format|
        format.html { @phrases = @locale.phrases_without_translation(params[:page]) }
        format.yml { render :text => @locale.to_hash.to_yaml }
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

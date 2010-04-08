module Tolk
  class LocalesController < ApplicationController
    before_filter :find_locale, :only => [:show, :all]
    before_filter :ensure_no_primary_locale, :only => :all

    def index
      @locales = Tolk::Locale.all
    end
  
    def show
      render :primary_locale if @locale.primary?
    end

    def all
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

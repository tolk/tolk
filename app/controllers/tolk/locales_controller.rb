module Tolk
  class LocalesController < ApplicationController
    def index
      @locales = Tolk::Locale.all
    end
  
    def show
      @locale = Tolk::Locale.find_by_name!(params[:id], :include => { :translations => {:phrase => :translations } })
      render :primary_locale if @locale.primary?
    end
  
    def create
      Tolk::Locale.create!(params[:tolk_locale])
      redirect_to :action => :index
    end
  end
end

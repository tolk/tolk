class LocalesController < ApplicationController
  def index
    @locales = Locale.all
  end
  
  def show
    @locale = Locale.find(params[:id])
  end
  
  def create
    redirect_to(Locale.create(params[:locale]))
  end
end
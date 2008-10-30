class LocalesController < ApplicationController
  before_filter :set_application
  
  def show
    @locale = @application.locales.find(params[:id])
  end
  
  
  def create
    @locale = @application.locales.create(params[:locale])
    redirect_to(@application)
  end
end
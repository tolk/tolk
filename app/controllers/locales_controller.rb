class LocalesController < ApplicationController
  before_filter :set_application
  
  def create
    @locale = @application.locales.create(params[:locale])
    redirect_to(@application)
  end
  
  private
    def set_application
      @application = Application.find(params[:application_id])
    end
end

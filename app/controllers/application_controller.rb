class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  
  private
    def set_application
      @application = Application.find(params[:application_id] || params[:id])
    end
end

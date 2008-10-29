class ApplicationsController < ApplicationController
  def index
    @applications = Application.all
  end
  
  def create
    application = Application.create(params[:application])
    redirect_to(application)
  end
  
  def show
    @application = Application.find(params[:id])
  end
end

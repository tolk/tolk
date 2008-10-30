class ApplicationsController < ApplicationController
  before_filter :set_application, :except => [ :index, :create ]
  
  def index
    @applications = Application.all
  end
  
  def create
    redirect_to(Application.create(params[:application]))
  end
  
  def show
  end
  
  def dump
    @application.dump
    redirect_to(@application)
  end
end

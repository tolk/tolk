class PhrasesController < ApplicationController
  before_filter :set_application

  def index
    @phrases = @application.phrases
  end
  
  def create
    translation_parameters = params[:phrase].delete(:translation)

    phrase      = @application.phrases.create(params[:phrase])
    translation = Translation.create(translation_parameters.merge(:phrase => phrase))

    redirect_to([ @application, translation.locale ])
  end
end
class PhrasesController < ApplicationController
  def index
    @phrases = Phrase.all
  end
  
  def create
    translation_parameters = params[:phrase].delete(:translation)

    phrase      = Phrase.all.create(params[:phrase])
    translation = Translation.create(translation_parameters.merge(:phrase => phrase))

    redirect_to(translation.locale)
  end
end
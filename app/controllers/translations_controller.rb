class TranslationsController < ApplicationController
  def create
  end
  
  def update
    @translation = Translation.find(params[:id])
    @translation.update_attributes!(params[:translation])
    head :ok
  end
end

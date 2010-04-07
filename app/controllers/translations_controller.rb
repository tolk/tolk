class TranslationsController < ApplicationController
  before_filter :ensure_no_primary_locale, :only => :update

  def create
    locale_id = params[:translation].delete(:locale_id)

    @locale = Locale.find(locale_id)
    @translation = @locale.translations.new(params[:translation])

    if @translation.save
      flash[:notice] = 'Translation saved'
    else
      flash[:alert] = 'Translation could not be saved'
    end

    redirect_to @locale
  end

  def update
    @translation = Translation.find(params[:id])
    @translation.update_attributes!(params[:translation])
    head :ok
  end
end

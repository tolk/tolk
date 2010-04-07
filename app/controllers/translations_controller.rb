class TranslationsController < TolkController
  before_filter :find_locale
  before_filter :ensure_no_primary_locale

  def create
    @translation = @locale.translations.new(params[:translation])

    if @translation.save
      flash[:notice] = 'Translation saved'
    else
      flash[:alert] = 'Translation could not be saved'
    end

    redirect_to @locale
  end

  def update
    @translation = @locale.translations.find(params[:id])
    @translation.update_attributes!(params[:translation])
    head :ok
  end

  private

  def find_locale
    locale_id = params[:translation].delete(:locale_id) if params[:translation]
    @locale = Locale.find(locale_id)
  end

  def ensure_no_primary_locale
    redirect_to locales_path if @locale.primary?
  end
end

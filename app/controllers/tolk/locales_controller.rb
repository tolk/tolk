module Tolk
  class LocalesController < Tolk::ApplicationController
    before_action :find_locale, :only => [:show, :update, :incomplete_translations, :completed_translations, :updated_translations]

    def index
      @locales = Tolk::Locale.all.sort_by(&:language_name)
    end

    def show
      redirect_to action: :incomplete_translations, id: @locale.name
    end

    def update
      translation_params = params.require(:tolk_locale).permit(translations_attributes: [:id, :phrase_id, :locale_id, :text])

      if @locale.update(translation_params)
        flash[:notice] = "Save Successful!"
        redirect_back(fallback_location: locale_path(@locale))
      else
        flash.now[:alert] = "Not Saved!"

        if params[:form_name] == "completed_translations"
          @phrases = @locale.phrases_with_translation(params[pagination_param])
          render "tolk/locales/#{params[:form_name]}"
        else
          @phrases = @locale.phrases_without_translation(params[pagination_param])
          render "tolk/locales/#{params[:form_name]}"
        end
      end
    end

    def incomplete_translations
      respond_to do |format|
        format.html do
          @action_name = params[:action]
            
          @phrases = @locale.phrases_without_translation(params[pagination_param])
        end

        format.atom { @phrases = @locale.phrases_without_translation(params[pagination_param]).per(50) }

        format.yaml do
          data = @locale.to_hash
          render :plain => Tolk::YAML.dump(data)
        end

      end
    end

    def completed_translations
      @action_name = params[:action]

      @phrases = @locale.phrases_with_translation(params[pagination_param])
    end

    def updated_translations
      @phrases = @locale.phrases_with_updated_translation(params[pagination_param])
      render :all
    end

    def create
      Tolk::Locale.create!(params.require(:tolk_locale).permit(:name))
      redirect_to :action => :index
    end

    def dump_all
      Tolk::Locale.dump_all
      I18n.reload!
      I18n::JS.export if defined? I18n::JS
      redirect_to request.referrer
    end

    def stats
      @locales = Tolk::Locale.secondary_locales.sort_by(&:language_name)

      respond_to do |format|
        format.json do
          stats = @locales.collect do |locale|
            [locale.name, {
              :missing => locale.count_phrases_without_translation,
              :updated => locale.count_phrases_with_updated_translation,
              :updated_at => locale.updated_at
            }]
          end
          render :json => Hash[stats]
        end
      end
    end

    private

    def find_locale
      @locale = Tolk::Locale.where('UPPER(name) = UPPER(?)', params[:id]).first!
    end

  end
end

module Tolk
  class LocalesController < Tolk::ApplicationController
    before_action :find_locale, :only => [:show, :all, :update, :updated]
    before_action :ensure_no_primary_locale, :only => [:all, :update, :show, :updated]

    def index
      @locales = Tolk::Locale.secondary_locales.sort_by(&:language_name)
    end

    def show
      respond_to do |format|
        format.html do
          @phrases = @locale.phrases_without_translation(params[pagination_param])
        end

        format.atom { @phrases = @locale.phrases_without_translation(params[pagination_param]).per(50) }

        format.yaml do
          data = @locale.to_hash
          render :text => Tolk::YAML.dump(data)
        end

      end
    end

    def update
      @locale.translations_attributes = translation_params
      @locale.save
      redirect_to request.referrer
    end

    def all
      @phrases = @locale.phrases_with_translation(params[pagination_param])
    end

    def updated
      @phrases = @locale.phrases_with_updated_translation(params[pagination_param])
      render :all
    end

    def create
      Tolk::Locale.create!(locale_params)
      redirect_to :action => :index
    end

    def dump_all
      Tolk::Locale.dump_all
      I18n.reload!
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

    def locale_params
      params.require(:tolk_locale).permit(:name)
    end

    def translation_params
      params.permit(translations: [:id, :phrase_id, :locale_id, :text])[:translations]
    end

  end
end

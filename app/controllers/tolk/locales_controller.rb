module Tolk
  class LocalesController < Tolk::ApplicationController
    before_action :find_locale, only: [:show, :edit, :update]

    def index
      @secondary_locales = Tolk::Locale.secondary.sort_by(&:language_name)
    end

    def create
      Tolk::Locale.create!(params.require(:tolk_locale).permit(:name))

      redirect_to action: :index
    end
    
    def show
      redirect_to action: :edit, id: @locale.name
    end

    def edit
      respond_to do |format|
        format.html do
          get_phrases
        end

        format.yaml do
          data = @locale.to_hash
          render plain: Tolk::YAML.dump(data)
        end
      end
    end

    def update
      translation_params = params.require(:tolk_locale).permit(translations_attributes: [:id, :phrase_id, :locale_id, :text])

      if @locale.update(translation_params)
        flash[:notice] = "Save Successful!"

        redirect_back(fallback_location: edit_locale_path(@locale))
      else
        flash.now[:alert] = "Not Saved!"

        asd

        get_phrases

        render "tolk/locales/edit"
      end
    end

    def dump_all
      Tolk::Locale.dump_all

      I18n.reload!

      if defined? I18n::JS
        I18n::JS.export 
      end

      redirect_back(fallback_location: locales_path)
    end

    def stats
      @locales = Tolk::Locale.secondary_locales.sort_by(&:language_name)

      respond_to do |format|
        format.json do
          stats = @locales.collect do |locale|
            [
              locale.name, 
              {
                missing: locale.phrases_without_translation.count,
                updated: locale.phrases.with_updated_translation.count,
                updated_at: locale.updated_at
              }
            ]
          end
          render json: Hash[stats]
        end
      end
    end

    private

    def find_locale
      @locale = Tolk::Locale.find_by!('UPPER(name) = UPPER(?)', params[:id])
    end

    def get_phrases
      case params[:filter]
      when "completed"
        @phrases = @locale.phrases.with_translation
      when "updated"
        @phrases = @locale.phrases.with_updated_translation
      else
        params[:filter] = "incomplete"

        existing_phrase_ids_for_locale = @locale.translations.where("tolk_translations.text IS NOT NULL").pluck(:phrase_id).uniq

        @phrases = Tolk::Locale.primary_locale.phrases.where.not(id: existing_phrase_ids_for_locale)
      end

      if params[:k].present?
        @phrases = @phrases.containing_text(params[:k])
      end

      if params[:q].present?
        @phrases = @phrases.search_translations(params[:q])
      end

      @phrases = @phrases.send(pagination_method, params[:page])
    end

  end
end

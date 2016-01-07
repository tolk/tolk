module Tolk
  class LocalesController < Tolk::ApplicationController
    before_filter :find_locale, :only => [:show, :all, :update, :updated]
    before_filter :find_source_language_name, :only => [:show]
    before_filter :ensure_no_primary_locale, :only => [:all, :update, :show, :updated]
    skip_load_and_authorize_resource
    load_resource :find_by => :name
    authorize_resource

    def index
      # hotfix
      # todo: rewrite to use Ability instead of this redirect
      redirect_to locale_path(@current_user.language.locale_shortcut) if @current_user.manager?

      @locales = Tolk::Locale.secondary_locales.sort_by(&:language_name)
    end

    def show
      # hotfix
      # todo: rewrite to use Ability instead of this redirect
      if @current_user.manager? && @current_user.language.locale_shortcut != @locale.name
        redirect_to locale_path(@current_user.language.locale_shortcut)
      end

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

    def find_source_language_name
      if params[:source].present? && params[:source].to_i > 0
        @source_language_name = Tolk::Locale.find(params[:source]).language_name
      else
        @source_language_name = Tolk::Locale.primary_language_name
      end
    end

  end
end

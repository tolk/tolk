module Tolk
  class SearchesController < Tolk::ApplicationController
    before_action :find_locale
  
    def show
      @phrases = @locale.search_phrases(params[:q], params[:scope].to_sym, params[:k], params[pagination_param])
    end

    private

    def find_locale
      @locale = Tolk::Locale.where('UPPER(name) = UPPER(?)', params[:tolk_locale]).first!
    end
  end
end

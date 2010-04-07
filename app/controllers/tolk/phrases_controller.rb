module Tolk
  class PhrasesController < ApplicationController
    def index
      @phrases = Tolk::Phrase.all
    end
  end
end

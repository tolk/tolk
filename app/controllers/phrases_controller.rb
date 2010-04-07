class PhrasesController < TolkController
  def index
    @phrases = Phrase.all
  end
end
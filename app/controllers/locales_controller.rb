class LocalesController < TolkController
  def index
    @locales = Locale.all
  end
  
  def show
    @locale = Locale.find_by_name!(params[:id])
    render :primary_locale if @locale.primary?
  end
  
  def create
    Locale.create!(params[:locale])
    redirect_to :action => :index
  end
end
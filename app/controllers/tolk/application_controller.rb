module Tolk
  class ApplicationController < ActionController::Base
    helper :all
    protect_from_forgery
  end
end

class ApplicationController < ActionController::Base
  
  before_filter :set_locale
  
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  
  protect_from_forgery
  
  # before_filter :authenticate
  # 
  # protected
  # 
  # def authenticate
  #   authenticate_or_request_with_http_basic do |username, password|
  #     username == "foo" && password == "bar"
  #   end
  # end
  
end
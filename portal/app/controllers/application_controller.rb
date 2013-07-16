class ApplicationController < ActionController::Base
  before_action CASClient::Frameworks::Rails::Filter,  :unless => :skip_login?

  before_action :current_user
  helper_method :current_user

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def skip_login? 
  	false 
  end


  private
  def current_user
  	@current_user ||= User.find(session[:id]) if session[:id]
  end
  	
 
end

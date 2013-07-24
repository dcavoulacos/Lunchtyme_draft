class ApplicationController < ActionController::Base
  before_action CASClient::Frameworks::Rails::Filter,  :unless => :skip_login?
  #before_action :update_existing_user, except: [:logout]
  before_action :create_new_user_if_not_exist , except: [:logout]
 
  before_action :current_user
  helper_method :current_user
  before_action :create_new_user_if_not_exist , except: [:logout]

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def skip_login? 
  	false 
  end


  private

    def current_user
      @current_user ||= User.find_by(netid: session[:cas_user])
    end

    def create_new_user_if_not_exist  
      unless current_user
        redirect_to new_user_path
      end
    end

  #def update_existing_user
   # if current_user
    #  redirect_to "/auth/facebook"  if ((Time.now - current_user.lastpullfromfacebook) > 100)
    #end
  #end


end
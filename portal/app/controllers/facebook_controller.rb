class FacebookController < ApplicationController
  def update
  	User.update_via_omniauth!(env["omniauth.auth"], current_user)
	redirect_to root_path	
  end
end

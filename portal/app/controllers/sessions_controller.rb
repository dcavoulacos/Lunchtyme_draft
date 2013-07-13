class SessionsController < ApplicationController
	def login
		@user = User.from_omniauth(env["omniauth.auth"])
		session[:id] = @user.id
		redirect_to root_url		
	end

	def logout
		session[:id] = nil
		redirect_to root_url
	end
end
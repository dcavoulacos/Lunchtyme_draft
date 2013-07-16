class SessionsController < ApplicationController
	
	skip_before_action :current_user, only: [:logout]

	def login
		session[:id] = nil
		@current_user = User.from_omniauth(env["omniauth.auth"])
		session[:id] = @current_user.id
		redirect_to root_url		
	end

	def logout
		@current_user = nil
		#session[:cas_user] = nil
		session[:id] = nil
		#RubyCAS::Filter.logout(self, root_path)
		redirect_to root_url
	end
end
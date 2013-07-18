class SessionsController < ApplicationController
	
	skip_before_action :current_user, only: [:logout]

	def login
		session[:id] = nil
		@current_user = User.from_omniauth(env["omniauth.auth"])
		#@current_user.res_college = self.college
		session[:id] = @current_user.id
		redirect_to root_path		
	end

	def logout
		session[:cas_user] = nil
		@current_user = nil
		session[:id] = nil
		CASClient::Frameworks::Rails::Filter.logout(self, root_path)
		#redirect_to root_url
	end
end
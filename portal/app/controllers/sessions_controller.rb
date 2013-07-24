class SessionsController < ApplicationController
	
	skip_before_action :current_user, only: [:logout]

	def login
		User.update_via_omniauth!(env["omniauth.auth"], current_user)
		redirect_to root_path	
	end

	def logout
		session = nil
		@current_user = nil
		CASClient::Frameworks::Rails::Filter.logout(self, root_path)
	end
end
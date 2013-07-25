class SessionsController < ApplicationController
	skip_before_action CASClient::Frameworks::Rails::Filter
	skip_before_action :update_existing_user
  	skip_before_action :create_new_user_if_not_exist
	skip_before_action :current_user, only: [:logout]

	def new
	end

	def login
		User.update_via_omniauth!(env["omniauth.auth"], current_user)
		redirect_to root_path	
	end

	def logout
		session = nil
		@current_user = nil
		logout_url = root_path
		CASClient::Frameworks::Rails::Filter.logout(self, root_path)
	end
end
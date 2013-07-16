class User < ActiveRecord::Base

	serialize :friends


	def self.from_omniauth(auth)
		where(auth.slice(:provider, :facebook_id)).first_or_initialize.tap do |user|
			user.provider = auth.provider
			user.facebook_id = auth.uid
			user.name = auth.info.name
			user.email = auth.info.email
			user.oauth_token = auth.credentials.token
			user.oauth_expires_at = Time.at(auth.credentials.expires_at)
			@graph = Koala::Facebook::API.new(user.oauth_token)
			user.friends = @graph.get_connections("me", "friends")
			#user.phone =
			#user.gender = 
			
			user.save!
		end
	end

	# def pull_facebook_friends
	# 	#oauth_access_token = Koala::Facebook::OAuth.new('598601033518548', 'a091edbee36349bac46a242c6131e778', 'auth/:provider/callback')
	# 	#binding.pry
	# 	#profile = @graph.get_object("me")
	# 	@graph = Koala::Facebook::API.new(self.oauth_token)
	# 	friendlist = @graph.get_connections("me", "friends")
		
	# 	self.friends = friendlist
	# end

end
#require 'net/ldap'
#require 'mechanize'

class User < ActiveRecord::Base
	has_many :schedules
	serialize :friends
	serialize :objectm
	serialize :likes
	serialize :mutualfriends
	has_many :matchings, :dependent => :destroy
	has_many :matches, -> { where("status = 'accepted") }, :through => :matchings
	has_many :requested_matches, -> { where("status = 'requested'").order(:created_at) }, :through => :matchings, :source => :match
	has_many :pending_matches, -> { where("status = 'pending'").order(:created_at) }, :through => :matchings, :source => :match

	validates :first_name, :last_name, :email, :phone, presence: true
	validates :first_name, :last_name, format: { with: /\A[a-zA-Z]+\z/, message: "Your name only has letters in it, right?" }
	validates :phone, format: { with: /[0-9]{10}/, message: "Please Insert a Valid Phone Number" }


	#after_create :send_welcome_email

	



	def self.update_via_omniauth!(auth, user)
		if  user.facebook_id == nil			
			user.provider = auth.provider
			user.lastpullfromfacebook = Time.now
				user.facebook_id = auth.uid.to_s
				user.name = auth.info.name
				user.email = auth.info.email
			user.oauth_token = auth.credentials.token
			user.oauth_expires_at = Time.at(auth.credentials.expires_at)
			@@graph = Koala::Facebook::API.new(user.oauth_token)
			user.objectm = @@graph.get_object("me")
			user.gender = user.objectm["gender"]
			user.imageurl = @@graph.get_picture(user.objectm["username"])
			user.friends = @@graph.get_connections("me", "friends")
			#user.likes = @@graph.get_connections("me", "likes")
			
				mutual_friends = []
				users = []
				User.all.each do |u|
					if u != user
						mutual_friends << @@graph.get_connections("me", "mutualfriends/#{u.facebook_id}").length
						users << u.facebook_id
					end
				end
				user.mutualfriends = Hash[users.zip(mutual_friends)]
         	user.save!
         	
		elsif user.facebook_id.to_s == auth.uid.to_s
			user.provider = auth.provider
			user.lastpullfromfacebook = Time.now
			user.oauth_token = auth.credentials.token
			user.oauth_expires_at = Time.at(auth.credentials.expires_at)
			@@graph = Koala::Facebook::API.new(user.oauth_token)
			user.objectm = @@graph.get_object("me")
			user.gender = user.objectm["gender"]
			user.imageurl = @@graph.get_picture(user.objectm["username"])
			user.friends = @@graph.get_connections("me", "friends")
			#user.likes = @@graph.get_connections("me", "likes")
			
				mutual_friends = []
				users = []
				User.all.each do |u|
					if u != user
						mutual_friends << @@graph.get_connections("me", "mutualfriends/#{u.facebook_id}").length
						users << u.facebook_id
					end
				end
				user.mutualfriends = Hash[users.zip(mutual_friends)]
         	user.save!
		else
			"You are not logged in with your own Facebook Account!"
		end
			#"https://graph.facebook.com/1463020126?fields=gender,first_name"
	end

	def facebook_friend?(user)
		return self.friends.values.include?(user.facebook_id)
	end
	
	NAME = KNOWN_AS = /^\s*Name:\s*$/i
	KNOWN_AS ||= /^\s*Known As:\s*$/i
	EMAIL = /^\s*Email Address:\s*$/i
	YEAR = /^\s*Class Year:\s*$/i
	SCHOOL = /^\s*Division:\s*$/i
	COLLEGE = /^\s*Residential College:\s*$/i
	LEAD_SPACE = /^\s+/
	TRAIL_SPACE = /\s+$/

		def make_cas_browser
	  browser = Mechanize.new
	  browser.get( 'https://secure.its.yale.edu/cas/login' )
	  form = browser.page.forms.first
	  form.username = ENV['netid']
	  form.password = ENV['netid_password']
	  form.submit
	  browser
	end

	def get_user
	  browser = make_cas_browser
	  netid = self.netid

	  browser.get("http://directory.yale.edu/phonebook/index.htm?searchString=uid%3D#{netid}")

	  fname = ""
	  browser.page.search('tr').each do |tr|
	    field = tr.at('th').text
	    value = tr.at('td').text.sub(LEAD_SPACE, '').sub(TRAIL_SPACE, '')
	    case field
	    when NAME
	      name = value.split(' ')
	      fname = name.first
	      self.last_name = name.last
	      self.first_name = fname 
	    when KNOWN_AS
	      self.first_name = value
	    when EMAIL
	  	  self.email = value
	    when COLLEGE
	      self.college = value
	    end
	  end
	end

	def search_ldap(login)
	  ldap = Net::LDAP.new(host: "directory.yale.edu", port: 389)
	  filter = Net::LDAP::Filter.eq("uid", login)
	  attrs = ["givenname", "sn", "eduPersonNickname", "telephoneNumber", "uid",
	           "mail", "collegename", "curriculumshortname", "college", "class"]
	  result = ldap.search(base: "ou=People,o=yale.edu", filter: filter, attributes: attrs)
		if !result.empty?
			fname  = result[0][:givenname][0]
			self.first_name = fname
			self.last_name   = result[0][:sn][0]
	    	@nickname = result[0][:eduPersonNickname]
			if !@nickname.empty?
			    self.first_name  = @nickname[0]
			end
			self.email   = result[0][:mail][0]
			self.res_college = result[0][:college][0]
			self.class_year = result[0][:class][0]
		end
	end

	def facebook_friend?(user)
		return self.friends.values.include?(user.facebook_id)
	end

	def has_valid_schedule?
		sched = self.schedules.where("day = ?", Time.now.strftime("%A")).first
		return false unless sched.present?
		sched.updated_at.today?
	end		 

	#validates :phone, :gender, presence: true
	#validates :handle, uniqueness: { case_sensitive: false }
	validates :phone, format: { with: /[0-9]+/,
    message: "Only use numbers" }


	private

	def send_welcome_email
 		UserMailer.welcome_email(self).deliver
	end

end
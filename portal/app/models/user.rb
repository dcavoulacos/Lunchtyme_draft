#require 'net/ldap'
#require 'mechanize'

class User < ActiveRecord::Base


	serialize :friends
	has_many :pending_matches,
         :through => :matchings,
         :source => :match,
         :conditions => "confirmed = 0"  # assuming 0 means 'pending'

	def self.from_omniauth(auth)

		where(auth.slice(:provider, :facebook_id)).first_or_initialize.tap do |user|
			#user = User.new
			user.provider = auth.provider
			user.facebook_id = auth.uid
			user.name = auth.info.name
			user.email = auth.info.email
			#"https://graph.facebook.com/1463020126?fields=gender,first_name"
			#user.gender = auth.gender
			user.oauth_token = auth.credentials.token
			user.oauth_expires_at = Time.at(auth.credentials.expires_at)
			@graph = Koala::Facebook::API.new(user.oauth_token)
        	user.friends = @graph.get_connections("me", "friends")
			user.save!
		end
	end













	
	NAME = KNOWN_AS = /^\s*Name:\s*$/i
	KNOWN_AS = /^\s*Known As:\s*$/i
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
		end
	end


end
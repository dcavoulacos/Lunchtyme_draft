class Matching < ActiveRecord::Base

	before_save :update_status

	belongs_to :user
	belongs_to :match, :class_name => 'User', :foreign_key => "match_id"

	def update_status
		complement = Matching.where(user_id: self.match_id, match_id: self.user_id, status: 'pending').first
		if complement
			complement.update_column(:status, "accepted")
			self.status = "accepted"
		end
	end
end
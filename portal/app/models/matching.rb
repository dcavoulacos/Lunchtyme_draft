class Matching < ActiveRecord::Base
	belongs_to :user
	belongs_to :match, :class_name => 'User', :foreign_key => "match_id"
end

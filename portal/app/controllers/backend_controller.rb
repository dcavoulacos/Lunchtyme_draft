class BackendController < ActionController::Base
	private

	def find_matches(user)
		return unless user.has_valid_schedule?
		potential_matches = []
		today = Time.now.strftime("%A")
		sched1 = user.schedules.where("day = ?", today).first
		user.matchings.find_by_status("accepted").each do |match|
			
			friend = User.find(match.match_id)
			break unless friend.has_valid_schedule?
			sched2 = friend.schedules.where("day = ?", today).first
			
			if sched1.location != sched2.location
				break
			elsif sched1.overlap_between_time_windows(sched1, sched2) < 30
				break			
			else
				potential_matches << friend
			end

		end
		return potential_matches
	end

end
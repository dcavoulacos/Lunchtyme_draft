class LunchPairer

	def self.compute_pairs
		list_of_users = []
		User.all.each do |user|
			matches = LunchPairer.find_matches(user)
			list_of_users << [user, matches] unless matches.empty?
		end
		list_of_users
	end

	def backtrack_pairer(current_users, current_matches, best_users, best_matches)

	end

	def self.greedy_pairer
		list_of_users = self.compute_pairs
		list_of_pairs = []
		while exist_pairable_user(list_of_users)
			user = list_of_users.first.first
			match = list_of_users.first.second.first
			clear_user_list(list_of_users.first, list_of_users)
			clear_user_list(list_of_users.assoc(match), list_of_users)
			list_of_pairs << [user, match]
			list_of_users.sort_by{|user_array| user_array.second.count}
		end
		return list_of_pairs
	end

	def self.exist_pairable_user(list_of_users)
		list_of_users.each do |user_array|
			if !user_array.second.empty?
				return true
			end
		end
		return false
	end

	def self.clear_user_list(user_array, list_of_users)
		user_to_clear = user_array.first
		matches_to_clear = user_array.second
		list_of_users.each do |user_array|
			if matches_to_clear.include?(user_array.first)
				user_array.second.delete(user_to_clear)
				matches_to_clear.delete(user_array.first)
			end
		end
		list_of_users.delete(user_to_clear)
	end

	def self.find_matches(user)
		return unless user.has_valid_schedule?
		potential_matches = []
		today = Time.now.strftime("%A")
		sched1 = user.schedules.where("day = ?", today).first
		user.matchings.where("status = ?", "accepted").each do |match|
			
			friend = User.find(match.match_id)
			if friend.has_valid_schedule?
				sched2 = friend.schedules.where("day = ?", today).first
				
				if sched1.location != sched2.location
				elsif sched1.overlap_between_time_windows(sched1, sched2) < 30	
				else
					potential_matches << friend
				end
			end
		end
		return potential_matches
	end	

end
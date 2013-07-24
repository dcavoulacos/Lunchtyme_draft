class Schedule < ActiveRecord::Base
  belongs_to :user

  def narrow_down_schedules
  	matches = Matching.where(status: "accepted")
  	matches.each do |match|
  		overlap_between_time_windows(match.user_id, match.match_id)
  	end
  	match.user_id
  	match.match_id
  end

  def convert_stringtime_to_clocktime(stringtime)
  	clocktime = stringtime[0.1].to_i + stringtime[3.4].to_i/60
  	clocktime += 12 if clocktime < 10
  end

  def location_match?(user1,user2)
  	user1.schedule.location == user2.schedule.location
  end

  def length_of_time_window(user)
  	return user.schedule.end_time-user.schedule.start_time 	
  end

  def overlap_between_time_windows(user1,user2)
  	if user2.schedule.start_time - user1.schedule.end_time > 0 
  		return 0 
  	elsif user1.schedule.start_time - user2.schedule.end_time > 0 
  		return 0
  	else 
  		return [user1.schedule.end_time, user2.schedule.end_time].min - [user1.schedule.start_time, user2.schedule.start_time].max
  	end 
  end
end
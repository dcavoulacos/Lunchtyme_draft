class Schedule < ActiveRecord::Base
  belongs_to :user


  validate :start_must_be_30mins_before_end_time

  def start_must_be_30mins_before_end_time
   errors.add(:end_time, "Must be 30 minutes after start time") unless start_time < end_time
  end

  # def convert_stringtime_to_clocktime(stringtime)
  # 	clocktime = stringtime[0.1].to_i + stringtime[3.4].to_i/60
  # 	clocktime += 12 if clocktime < 10
  # end

  # def narrow_down_schedules
  # 	matches = Matching.where(status: "accepted")
  # 	matches.each do |match|
  # 	  overlap_between_time_windows(match.user_id, match.match_id)
  # 	end
  # 	match.user_id
  # 	match.match_id
  # end

  def convert_time(time_string)
  	hour = time_string.split(':').first.to_i
  	minute = time_string.split(':').last.to_i
  	hour += 12 unless hour > 3
 		return (hour*100 + minute)
  end

  def time_for_lunch(user)
  	convert_time(user.schedule.end_time) - convert_time(user.schedule.start_time)	
  end

  def overlap_between_time_windows(sched1, sched2)
  	start1 = convert_time(sched1.start_time)
  	end1 = convert_time(sched1.end_time)
  	start2 = convert_time(sched2.start_time)
  	end2 = convert_time(sched2.end_time)

  	if (start2 - end1 > 0) || (start1 - end2 > 0)
  		return 0 
   	else 
   		time_start = [start1, start2].max
   		time_end = [end1, end2].min
   		return (time_end%100 + 60*(time_end/100)) - (time_start%100 + 60*(time_start/100))
  	end 
  end

end
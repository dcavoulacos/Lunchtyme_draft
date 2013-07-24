class Schedule < ActiveRecord::Base
  belongs_to :user

  def convert_time(time_string)
  	hour = time_string.split(':').first.to_i
  	minute = time_string.split(':').last.to_i
  	hour += 12 unless hour > 3
  	return (hour*100 + minute)
  end

end
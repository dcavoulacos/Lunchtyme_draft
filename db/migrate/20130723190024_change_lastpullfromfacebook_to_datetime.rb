class ChangeLastpullfromfacebookToDatetime < ActiveRecord::Migration
  def change
  	change_column :users, :lastpullfromfacebook, :datetime
  end
end

class ChangeFriendsToText < ActiveRecord::Migration
  def change
  	change_column :users, :friends, :text
  end
end

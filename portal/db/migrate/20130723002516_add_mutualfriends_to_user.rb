class AddMutualfriendsToUser < ActiveRecord::Migration
  def change
    add_column :users, :mutualfriends, :text
  end
end

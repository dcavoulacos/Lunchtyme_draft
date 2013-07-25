class AddLastpullfromfacebookToUser < ActiveRecord::Migration
  def change
    add_column :users, :lastpullfromfacebook, :datetime
  end
end

class AddLastpullfromfacebookToUser < ActiveRecord::Migration
  def change
    add_column :users, :lastpullfromfacebook, :time
  end
end

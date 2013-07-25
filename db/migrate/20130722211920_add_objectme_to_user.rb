class AddObjectmeToUser < ActiveRecord::Migration
  def change
    add_column :users, :objectm, :text
  end
end

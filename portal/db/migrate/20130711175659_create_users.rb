class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.integer :class_year
      t.string :res_college
      t.string :email
      t.string :phone
      t.string :gender
      t.integer :facebook_id

      t.timestamps
    end
  end
end

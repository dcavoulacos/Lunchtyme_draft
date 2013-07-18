class CreateMatchings < ActiveRecord::Migration
  def change
    create_table :matchings do |t|
      t.integer :user_id
      t.integer :match_id
      t.timestamps
    end

    add_index :matchings, [:user_id, :match_id]
  end
end

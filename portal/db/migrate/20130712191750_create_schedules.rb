class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.references :user, index: true
      t.datetime :day
      t.integer :start_time
      t.integer :end_time
      t.string :location

      t.timestamps
    end
  end
end

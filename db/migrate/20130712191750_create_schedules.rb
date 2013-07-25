class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.references :user, index: true
      t.string :day
      t.string :start_time
      t.string :end_time
      t.string :location

      t.timestamps
    end
  end
end

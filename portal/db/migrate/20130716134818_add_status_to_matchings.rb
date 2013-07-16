class AddStatusToMatchings < ActiveRecord::Migration
  def change
    add_column :matchings, :status, :string
  end
end

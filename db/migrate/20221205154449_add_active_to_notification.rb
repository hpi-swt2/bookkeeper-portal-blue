class AddActiveToNotification < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :active, :boolean, null: false, default: false
  end
end

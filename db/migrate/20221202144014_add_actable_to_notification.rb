class AddActableToNotification < ActiveRecord::Migration[7.0]
  def change
    change_table :notifications, &:actable
  end
end

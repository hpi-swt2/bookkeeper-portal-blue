class AddUnreadToNotification < ActiveRecord::Migration[7.0]
  def change
    add_column :notifications, :unread, :boolean
  end
end

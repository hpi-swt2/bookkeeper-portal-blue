class ChangeNotificationsUserToReceiver < ActiveRecord::Migration[7.0]
  def change
    rename_column :notifications, :user_id, :receiver_id
  end
end

class RemoveOwnerIdFromReturnDeclinedNotification < ActiveRecord::Migration[7.0]
  def change
    remove_column :return_declined_notifications, :owner_id, :integer
  end
end

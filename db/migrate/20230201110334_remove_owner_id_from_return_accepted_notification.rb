class RemoveOwnerIdFromReturnAcceptedNotification < ActiveRecord::Migration[7.0]
  def change
    remove_column :return_accepted_notifications, :owner_id, :integer
  end
end

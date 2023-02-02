class RemoveItemNameFromReturnDeclinedNotification < ActiveRecord::Migration[7.0]
  def change
    remove_column :return_declined_notifications, :item_name, :string
  end
end

class AddItemToReturnDeclinedNotification < ActiveRecord::Migration[7.0]
  def change
    add_reference :return_declined_notifications, :item, null: true, foreign_key: true
  end
end

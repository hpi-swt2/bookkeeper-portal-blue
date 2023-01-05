class AddAcceptedToLendRequestNotification < ActiveRecord::Migration[7.0]
  def change
    add_column :lend_request_notifications, :accepted, :boolean
  end
end

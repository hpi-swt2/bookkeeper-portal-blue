class AddAcceptedToReturnRequestNotification < ActiveRecord::Migration[7.0]
  def change
    add_column :return_request_notifications, :accepted, :boolean
  end
end

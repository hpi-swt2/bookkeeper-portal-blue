class RemoveNotificationSnippet < ActiveRecord::Migration[7.0]
  def change
    remove_column :notifications, :notification_snippet, :string
  end
end

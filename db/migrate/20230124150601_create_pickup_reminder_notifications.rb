class CreatePickupReminderNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :pickup_reminder_notifications do |t|
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end

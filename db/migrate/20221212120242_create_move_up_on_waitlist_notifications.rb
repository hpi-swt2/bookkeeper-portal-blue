class CreateMoveUpOnWaitlistNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :move_up_on_waitlist_notifications do |t|
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end

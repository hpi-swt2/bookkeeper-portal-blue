class CreateLendRequestNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :lend_request_notifications do |t|
      t.references :borrower, null: false, foreign_key: { to_table: :users }
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end

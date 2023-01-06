class CreateLendingAcceptedNotification < ActiveRecord::Migration[7.0]
  def change
    create_table :lending_accepted_notifications do |t|
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end

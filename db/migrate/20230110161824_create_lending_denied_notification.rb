class CreateLendingDeniedNotification < ActiveRecord::Migration[7.0]
  def change
    create_table :lending_denied_notifications do |t|
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end

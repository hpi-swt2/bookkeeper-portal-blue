class CreateTableAddedToGroupNotification < ActiveRecord::Migration[7.0]
  def change
    create_table :added_to_group_notifications do |t|
      t.string :group_name
      t.timestamps
    end
  end
end

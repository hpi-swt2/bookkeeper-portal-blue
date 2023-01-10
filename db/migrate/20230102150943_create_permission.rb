class CreatePermission < ActiveRecord::Migration[7.0]
  def change
    create_table :permissions do |t|
      t.string :type
      t.references :item, null: false, foreign_key: true
      t.references :user_or_group, polymorphic: true, null: false

      t.index [:item_id, :user_or_group_id, :user_or_group_type], unique: true,
                                                                  name: 'index_permission_on_item_and_user_or_group'
      t.timestamps
    end
  end
end

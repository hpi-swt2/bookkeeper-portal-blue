class ChangeHolderInItemToReferenceToUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :items, :holder, :string
    add_reference :items, :user, null: true, foreign_key: true
    rename_column :items, :user_id, :holder
  end
end

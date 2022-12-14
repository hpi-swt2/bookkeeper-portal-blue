class ChangeHolderInItemToReferenceToUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :items, :holder, :string
    add_reference :items, :holder, null: true, foreign_key: { to_table: :users }
    rename_column :items, :holder_id, :holder
  end
end

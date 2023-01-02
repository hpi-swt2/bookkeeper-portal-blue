class MigrateItemOwner < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :items, :users, column: :owner
    remove_column :items, :owner
  end
end

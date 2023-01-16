class MigrateItemOwner < ActiveRecord::Migration[7.0]
  def change
    Item.all.each do |item|
      item.owning_user = User.find(item.owner)
    end
    remove_foreign_key :items, :users, column: :owner
    remove_column :items, :owner, :integer
  end
end

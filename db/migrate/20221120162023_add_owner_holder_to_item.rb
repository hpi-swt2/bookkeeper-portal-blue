class AddOwnerHolderToItem < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :owner, :string
    add_column :items, :holder, :string
  end
end

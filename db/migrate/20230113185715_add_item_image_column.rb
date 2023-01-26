class AddItemImageColumn < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :image, :binary
  end
end

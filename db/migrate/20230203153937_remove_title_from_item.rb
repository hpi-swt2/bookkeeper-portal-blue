class RemoveTitleFromItem < ActiveRecord::Migration[7.0]
  def change
    remove_column :items, :title, :string
  end
end

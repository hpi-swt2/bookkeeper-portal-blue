class AddWishlistToUser < ActiveRecord::Migration[7.0]
  def change
    create_join_table :users, :items, table_name: :wishlist
  end
end

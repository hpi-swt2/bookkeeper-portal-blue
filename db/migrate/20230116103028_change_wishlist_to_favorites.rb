class ChangeWishlistToFavorites < ActiveRecord::Migration[7.0]
  def change
    rename_table :wishlist, :favorites
  end
end

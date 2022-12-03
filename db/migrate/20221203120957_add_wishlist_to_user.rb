class AddWishlistToUser < ActiveRecord::Migration[7.0]
  def change
    create_table :items_users, id: false do |t|
      t.belongs_to :user
      t.belongs_to :item

      t.timestamps
    end
  end
end

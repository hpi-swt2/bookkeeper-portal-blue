class ChangeUserIdToOwnerInItems < ActiveRecord::Migration[7.0]
  def change
    rename_column :items, :user_id, :owner
  end
end

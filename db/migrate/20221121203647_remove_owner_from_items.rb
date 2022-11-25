class RemoveOwnerFromItems < ActiveRecord::Migration[7.0]
  def change
    remove_column :items, :owner, :string
  end
end

class AddLendStatusToItems < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :lend_status, :integer, default: 0
  end
end

class AddLendApproveDateToItems < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :lend_approve_date, :timestamp
  end
end

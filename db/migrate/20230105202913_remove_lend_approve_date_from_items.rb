class RemoveLendApproveDateFromItems < ActiveRecord::Migration[7.0]
  def change
    remove_column :items, :lend_approve_date, :timestamp
  end
end

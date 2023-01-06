class AddJobIdToItems < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :job_id, :integer
  end
end

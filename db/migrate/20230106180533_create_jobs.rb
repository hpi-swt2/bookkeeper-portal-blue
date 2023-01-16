class CreateJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :jobs do |t|
      t.belongs_to :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end

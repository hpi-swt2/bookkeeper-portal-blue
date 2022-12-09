class CreateMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :memberships do |t|
      t.string :type
      t.references :group, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.index [:group_id, :user_id], unique: true
      t.timestamps
    end
  end
end

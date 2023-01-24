class CreateAuditEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :audit_events do |t|
      t.references :item, null: false, foreign_key: true
      t.references :holder, null: true, foreign_key: { to_table: :users }
      t.references :triggering_user, null: false, foreign_key: { to_table: :users }
      t.integer :event_type

      t.timestamps
    end
  end
end

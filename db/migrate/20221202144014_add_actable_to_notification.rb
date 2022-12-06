class AddActableToNotification < ActiveRecord::Migration[7.0]
  def change
    change_table :notifications do |t|
      t.actable
    end
  end
end

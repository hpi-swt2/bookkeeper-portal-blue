class RenameItemsColumnRentalDurationSec < ActiveRecord::Migration[7.0]
  def change
    rename_column :items, :rental_duration_days, :rental_duration_days
  end
end

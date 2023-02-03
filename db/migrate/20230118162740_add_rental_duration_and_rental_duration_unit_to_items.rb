class AddRentalDurationAndRentalDurationUnitToItems < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :rental_duration, :integer
    add_column :items, :rental_duration_unit, :string
  end
end

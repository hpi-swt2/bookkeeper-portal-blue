class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name
      t.string :category
      t.string :location
      t.text :description
      t.integer :price_ct
      t.integer :rental_duration_sec
      t.timestamp :rental_start
      t.text :return_checklist

      t.timestamps
    end
  end
end

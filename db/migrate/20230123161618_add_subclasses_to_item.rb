class AddSubclassesToItem < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :type, :string, {default: "OtherItem"}
    add_column :items, :title, :string, null: true
    add_column :items, :author, :string, null: true
    add_column :items, :genre, :string, null: true
    add_column :items, :page_count, :integer, null: true
    add_column :items, :movie_duration, :integer, null: true
    add_column :items, :player_count, :integer, null: true
  end
end

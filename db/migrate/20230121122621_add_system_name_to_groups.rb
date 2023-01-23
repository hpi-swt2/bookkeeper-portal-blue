class AddSystemNameToGroups < ActiveRecord::Migration[7.0]
  def change
    add_column :groups, :system_name, :string, { default: nil }
  end
end

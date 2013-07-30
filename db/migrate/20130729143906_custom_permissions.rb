class CustomPermissions < ActiveRecord::Migration
  def change
    add_column :permissions, :type, :string
    add_column :permissions, :name, :string
    add_column :permissions, :description, :text
    add_column :permissions, :actor_id, :integer
  end
end

class PermissionForeignKey < ActiveRecord::Migration
  def up
    add_index :permissions, :actor_id
    add_foreign_key :permissions, :actors
  end

  def down
    remove_foreign_key :permissions, :actors
    remove_index :permissions, :actor_id
  end
end

class PermissionsXml < ActiveRecord::Migration
  def change
    add_column :permissions, :xml, :text
  end
end

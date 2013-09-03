class CloudMaster < ActiveRecord::Migration
  def change
    add_column :users, :cloud_master, :boolean, default: false
    add_column :sites, :cloud, :boolean, default: false
    add_column :relations, :cloud, :boolean, default: false
  end
end

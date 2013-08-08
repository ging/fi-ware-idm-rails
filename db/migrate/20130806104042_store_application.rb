class StoreApplication < ActiveRecord::Migration
  def change
    add_column :sites, 'store', :boolean, default: false
  end
end

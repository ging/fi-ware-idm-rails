class AlterExternalIdp < ActiveRecord::Migration
  def up
		rename_column  :external_idps, :url, :route
		add_column :external_idps, :url, :string, :default => "", :null => false
  end

  def down
		remove_column  :external_idps, :url
		rename_column :external_idps, :route, :url
  end
end

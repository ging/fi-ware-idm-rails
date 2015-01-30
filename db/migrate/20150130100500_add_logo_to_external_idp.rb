class AddLogoToExternalIdp < ActiveRecord::Migration
  def change
    add_column :external_idps, :logo, :string
  end
end

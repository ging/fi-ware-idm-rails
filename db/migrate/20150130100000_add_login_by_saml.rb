class AddLoginBySaml < ActiveRecord::Migration
  def change
    add_column :users, :by_saml,  :boolean, :default => false
  end
end

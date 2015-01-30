class ModifyUsersForExternalIdp < ActiveRecord::Migration
  def up
    remove_column :users, :by_saml
    add_column :users, :ext_idp,  :integer

    # foreign key
    execute <<-SQL
      ALTER TABLE users
        ADD CONSTRAINT fk_users_external_idps
        FOREIGN KEY (ext_idp)
        REFERENCES external_idps(id)
    SQL
  end

  def down
    execute <<-SQL
     ALTER TABLE users DROP FOREIGN KEY fk_users_external_idps
    SQL
    remove_column :users, :ext_idp
    add_column :users, :by_saml,  :boolean, :default => false
  end
end

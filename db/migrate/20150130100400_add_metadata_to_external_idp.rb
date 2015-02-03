class AddMetadataToExternalIdp < ActiveRecord::Migration
  def up
    
    # foreign key
    execute <<-SQL
      ALTER TABLE external_idps
        MODIFY COLUMN
        route VARBINARY(255)
    SQL
    add_column :external_idps, :metadata, :string
    
  end
  

  def down
		
		change_column :external_idps, :route, :string
    remove_column :external_idps, :metadata
    
  end
end

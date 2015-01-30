class CreateExternalSps < ActiveRecord::Migration
  def self.up
    
    create_table :external_sps do |t|
      t.boolean :enabled, :default => true
      t.string :mark, :null => false
      t.string :description, :default => ""
      t.string :url, :null => false, :default => ""
      t.string :metadata
      t.string :logo
      
      t.timestamps
    end
 
  end

  def self.down
    drop_table :external_sps
  end

end

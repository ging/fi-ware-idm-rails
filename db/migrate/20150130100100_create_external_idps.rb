class CreateExternalIdps < ActiveRecord::Migration
  def self.up
    create_table :external_idps do |t|
      t.string :url, :null => false
      t.boolean :enabled, :default => true
      t.string :mark, :null => false
      t.string :description, :default => ""

      t.timestamps
    end
  end

  def self.down
    drop_table :external_idps
  end

end

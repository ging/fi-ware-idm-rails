class FiwareApplication < ActiveRecord::Migration
  def up
    change_table :sites do |t|
      t.column :fiware, :integer, default: nil
    end

    Application.reset_column_information

    [ :cloud, :store ].each do |s|
      Application.where(s => true).all.each do |app|
        app.update_attribute :fiware, Application::OFFICIAL.index(s)
      end
    end

    Application.where(official: true, cloud: false, store: false).all.each do |app|
      app.update_attribute :fiware, Application::OFFICIAL.index(:mashup)
    end

    remove_column :sites, :official
    remove_column :sites, :cloud
    remove_column :sites, :store

    rename_column :sites, :fiware, :official

    Application.reset_column_information
  end
  
  def down
  end
end

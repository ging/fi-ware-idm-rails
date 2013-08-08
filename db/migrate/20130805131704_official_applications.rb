class OfficialApplications < ActiveRecord::Migration
  def change
    add_column :sites, 'official', :boolean, default: false
  end
end

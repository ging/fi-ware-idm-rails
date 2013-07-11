class UpgradeClientsToApplications < ActiveRecord::Migration
  def up
    Site::Client.all.each do |c|
      c.update_attribute :type, "Application"
    end
  end

  def down
  end
end

class GroupType < ActiveRecord::Migration
  def change
    change_table :groups do |t|
      t.string :type
    end

    Group.record_timestamps = false

    Group.all.each do |g|
      g.update_attribute :type, 'Organization'
    end
  end
end

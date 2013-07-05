class GroupType < ActiveRecord::Migration
  def change
    change_table :groups do |t|
      t.string :type
    end
  end
end

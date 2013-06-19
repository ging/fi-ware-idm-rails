# This migration comes from social_stream_oauth2_server_engine (originally 20130619134332)
class SiteClientAdminToCustom < ActiveRecord::Migration

  class Relation::Admin < Relation; end

  def up
    Site::Client.all.each do |c|
      Relation::Custom.defaults_for c.actor
    end

    rt = Tie.record_timestamps
    Tie.record_timestamps = false

    Relation::Admin.first.ties.each do |t|
      t.relation = t.sender.relation_customs.sort.first
      t.save!
    end

    Tie.record_timestamps = rt
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

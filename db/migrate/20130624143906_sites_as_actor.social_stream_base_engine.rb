# This migration comes from social_stream_base_engine (originally 20130125100112)
class SitesAsActor < ActiveRecord::Migration
  def change
    add_column :sites, :type, :string

    rt = Site.record_timestamps
    Site.record_timestamps = false

    Site.all.each{ |s| s.update_attribute :type, "Site::Client" }

    Site.record_timestamps = rt
  end
end

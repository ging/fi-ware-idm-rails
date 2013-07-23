# This migration comes from social_stream_base_engine (originally 20130708152633)
class SetGroupOwners < ActiveRecord::Migration
  def up
    o_id = ::Relation::Owner.instance.id

=begin
    Group.all.each do |g|
      highest_rel = g.relation_customs.sort.last

      highest_rel.contacts.each do |c|
        unless c.relation_ids.include? o_id
          c.ties.create! relation_id: o_id
        end
      end
    end
=end
  end

  def down
    ::Relation::Owner.instance.ties.destroy_all
  end
end

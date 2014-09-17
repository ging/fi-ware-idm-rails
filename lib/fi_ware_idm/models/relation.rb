module FiWareIdm
  module Models
    module Relation
      extend ActiveSupport::Concern

      def trigger_policy_save
      end

      def api_attributes(options={})
        options[:includeResources] = true unless options[:includeResources]==false
        
        attrs = Hash.new
        attrs["id"] = self.id
        attrs["actor_id"] = self.actor_id
        attrs["type"] = self.type
        attrs["name"] = self.name
        attrs["created_at"] = self.created_at
        attrs["updated_at"] = self.updated_at
        attrs
      end
    end
  end
end

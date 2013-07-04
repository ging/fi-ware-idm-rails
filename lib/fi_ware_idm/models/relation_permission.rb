module FiWareIdm
  module Models
    module RelationPermission
      extend ActiveSupport::Concern
      
      included do
        after_save :trigger_policy_save
        after_destroy :trigger_policy_save
      end

      def trigger_policy_save
        relation.trigger_policy_save
      end
    end
  end
end

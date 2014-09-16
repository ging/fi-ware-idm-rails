module FiWareIdm
  module Models
    module Relation
      extend ActiveSupport::Concern

      def trigger_policy_save
      end

      def api_attributes
        self.attributes
      end
    end
  end
end

module FiWareIdm
  module Models
    module Tie
      extend ActiveSupport::Concern

      included do
        def relation_belongs_to_sender_with_get?
          relation_belongs_to_sender_without_get? ||
            relation_got_by_sender?
        end

        alias_method_chain :relation_belongs_to_sender?, :get
      end

      private

      def relation_got_by_sender?
        sender.obtained_roles.include? relation
      end
    end
  end
end

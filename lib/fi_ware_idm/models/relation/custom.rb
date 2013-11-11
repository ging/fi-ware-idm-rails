require 'fi_ware_idm/models/relation/custom'

module FiWareIdm
  module Models
    module Relation
      module Custom
        extend ActiveSupport::Concern

        included do
          attr_accessor :acge_error

          before_save :trigger_policy_save
          before_destroy :trigger_policy_save

          alias_method_chain :available_permissions, :custom
        end

        module ClassMethods
          private

          def create_activity?
            false
          end
        end

        def trigger_policy_save
          if subject.is_a? Site::Client
            subject.trigger_policy_save
          end
        rescue StandardError => e
          self.acge_error = e.to_s
        end

        def available_permissions_with_custom
          default = available_permissions_without_custom.dup

          if subject.is_a?(::Application)
            default += subject.permission_customs
          end

          default
        end
      end
    end
  end
end

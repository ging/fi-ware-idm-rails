require 'fi_ware_idm/models/relation/custom'

module FiWareIdm
  module Models
    module Relation
      module Custom
        extend ActiveSupport::Concern

        included do
          after_save :trigger_policy_save
          after_destroy :trigger_policy_save

          alias_method_chain :available_permissions, :custom
        end

        def trigger_policy_save
          if subject.is_a? Site::Client
            subject.trigger_policy_save
          end
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

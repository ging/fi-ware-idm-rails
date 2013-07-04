require 'fi_ware_idm/models/relation/custom'

module FiWareIdm
  module Models
    module Relation
      module Custom
        extend ActiveSupport::Concern

        included do
          after_save :trigger_policy_save
          after_destroy :trigger_policy_save
        end

        def trigger_policy_save
          if subject.is_a? Site::Client
            subject.trigger_policy_save
          end
        end
      end
    end
  end
end

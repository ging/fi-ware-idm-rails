module FiWareIdm
  module Models
    module Site
      module Client
        extend ActiveSupport::Concern

        def roles
          relations_list
        end

        def trigger_policy_save
          XacmlPolicy.new self
        end
      end
    end
  end
end

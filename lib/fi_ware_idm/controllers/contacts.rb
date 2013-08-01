module FiWareIdm
  module Controllers
    module Contacts
      extend ActiveSupport::Concern

      included do
        before_filter :redirect_to_organizations, only: [ :index ]
      end

      private

      def redirect_to_organizations
        if current_subject.is_a? User
          redirect_to :organizations
        end
      end
    end
  end
end

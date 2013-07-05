module FiWareIdm
  module Models
    module Actor
      extend ActiveSupport::Concern

      def applications
        managed_site_clients
      end

      def organizations
        []
      end
    end
  end
end

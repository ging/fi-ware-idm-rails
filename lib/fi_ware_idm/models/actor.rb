module FiWareIdm
  module Models
    module Actor
      extend ActiveSupport::Concern

      def applications
        managed_site_clients
      end

      def organizations
        Organization.
          select("DISTINCT groups.*").
          joins(actor: { sent_contacts: :relations }).
          merge(::Contact.received_by(self)).
          merge(::Relation.positive)
      end
    end
  end
end

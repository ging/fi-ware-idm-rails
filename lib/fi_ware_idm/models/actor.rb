module FiWareIdm
  module Models
    module Actor
      extend ActiveSupport::Concern

      included do
        # This must overwrite a class method in Actor
        def options_for_contact_select
          @options_for_contact_select ||=
            build_options_for_contact_select
        end

        def options_for_contact_select_simple?
          (relations_list + obtained_roles).count == 1
        end

        has_many :permission_customs,
                 class_name: "Permission::Custom",
                 dependent: :destroy
      end

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

      def other_organizations
        Organization.
          where(Organization.arel_table[:id].not_in(organizations.pluck(:id)))
      end

      # All the applications that grant this actor the ability to
      # obtain roles
      def obtained_applications
        ::Application.official |
          ::Application.granting_roles(self)
      end

      def obtained_roles
        @obtained_roles ||=
          obtained_applications.map{ |a| a.relation_customs }.flatten
      end

      def obtained_options_for_contact_select
        obtained_applications.inject({}){ |h, a|
          h[a.name] = a.relation_customs.map{ |r| [ r.name, r.id ] }
          h
        }
      end

      protected

      def build_options_for_contact_select
        if subject.is_a? ::Application
          relations_for_select.map{ |r| [ r.name, r.id ] }
        else
          {
            name => relations_for_select.map{ |r| [ r.name, r.id ] }
          }.merge(obtained_options_for_contact_select)
        end
      end
    end
  end
end

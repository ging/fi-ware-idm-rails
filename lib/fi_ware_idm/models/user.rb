module FiWareIdm
  module Models
    module User
      extend ActiveSupport::Concern

      included do
        # Overwrite User#represented method
        #
        # Right now, we do not need confirmation from users to represent
        def represented
          contact_subjects(direction: :received) do |q|
            q.joins(sent_ties: { relation: :permissions }).
              merge(Permission.represent)
          end
        end

        alias_method_chain :as_json, :organizations
      end

      # Overwrite application role information in JSON
      def as_json_with_organizations options = {}
        hash = as_json_without_organizations options

        ties = ties_from_organizations

        return hash if ties.blank?

        hash['organizations'] = []

        ties_from_organizations_hash.each_pair do |org, roles|
          hash['organizations'] << {
            id: org.subject.id,
            actorId: org.id,
            displayName: org.name,
            roles: roles.map{ |r|
              {
                id: r.id,
                name: r.name
              }
            }
          }
        end

        hash
      end

      # Grab all the ties sent by organizations received by this user
      def ties_from_organizations
        ::Tie.
          joins(sender: :group).
          includes(:sender, :relation).
          merge(Group.where(type: 'Organization')).
          received_by(self)
      end

      # Maps ties_from_organizations into a hash of organization and roles
      #   {
      #     organization1: [ role1, role2 ],
      #     organization2: [ role3 ]
      #   }
      def ties_from_organizations_hash
        ties_from_organizations.inject({}) do |hash, tie|
          hash[tie.sender] ||= []
          hash[tie.sender] << tie.relation
          hash
        end
      end
    end
  end
end

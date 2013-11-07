module FiWareIdm
  module Models
    module User
      extend ActiveSupport::Concern

      included do
        validates :email,
                  format: {
                    with: /.*@#{ FiWareIdm.allowed_email_domains.join('|') }/,
                    if: Proc.new { FiWareIdm.allowed_email_domains.present? },
                    message: "domain you have provided is not on the list of allowed partners (PPP member institutions). Please ensure that you supply a corporate address. Failing this, contact fiware-testbed-help@lists.fi-ware.eu and an administrator will add your domain to the list" 
                  }

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

      # Authorize FiWARE apps by default
      def client_authorized?(app)
        app.official? || super
      end

      # Overwrite application role information in JSON
      def as_json_with_organizations options = {}
        hash = as_json_without_organizations options

        ties = ties_from_organizations(options[:client])

        return hash if ties.blank?

        hash['organizations'] = []

        # Maps ties_from_organizations into a hash of organization and roles
        #   {
        #     organization1: [ role1, role2 ],
        #     organization2: [ role3 ]
        #   }
        ties_hash = ties.inject({}) do |hash, tie|
          hash[tie.sender] ||= []
          hash[tie.sender] << tie.relation
          hash
        end

        ties_hash.each_pair do |org, roles|
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
      def ties_from_organizations(application)
        return if application.blank?
       
        if application.cloud? && cloud_master?
          return ties_from_cloud_master
        end

        role_ids = application.custom_roles.map(&:id)

        return if role_ids.blank?

        ::Tie.
          joins(sender: :group).
          includes({ sender: :group }, :relation).
          merge(Group.where(type: 'Organization')).
          merge(::Relation.where(id: role_ids)).
          received_by(self)
      end

      def ties_from_cloud_master
        ::Actor.
          where(subject_type: [ "User", "Group" ]).
          all.
          map{ |a|
            ::Tie.new sender: a,
                      relation: ::Relation.where(cloud: true).first
          }
      end
    end
  end
end

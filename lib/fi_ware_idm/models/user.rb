module FiWareIdm
  module Models
    module User
      extend ActiveSupport::Concern

      included do
        validates :email,
                  format: {
                    with: /(#{ FiWareIdm.allowed_email_domains.join('|') })$/,
                    if: Proc.new { FiWareIdm.allowed_email_domains.present? },
                    message: ": the e-mail domain is not valid. Please note that you are signing up to the FI-WARE Testbed, restricted to PPP members. If you are a PPP member, please use your corporate email (not gmail, yahoo, etc.). If you are not a PPP member, you can apply for an account in FI-WARE (http://fi-ware.org/), that is suitable for anyone, PPP member or not.
                    
                    If you are a PPP member using your corporate e-mail address and you get this message, please contact the support team at fiware-testbed-help@lists.fi-ware.org to add your domain name to our white list.
        
        Important: a given domain on the white list authorises e-mail adresses in all the subdomains under it."
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

      def as_scim_json(version,controller)
        {
          schemas: ["urn:scim:schemas:core:2.0:User"],
          id: actor.id,
          userName: email,
          name: {
            formatted: CGI::escapeHTML(name)
          },
          displayedName: CGI::escapeHTML(name),
          meta: {
            resourceType: "User",
            created: created_at,
            lastModified: updated_at,
            version: "1",
            location: controller.request.url
          },
          profileUrl: controller.root_url[0..-2] + controller.user_path(self),
          emails: [
            {
              value: email,
              primary: "true"
            }
          ]
        }
      end
    end
  end
end

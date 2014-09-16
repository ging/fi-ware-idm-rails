module FiWareIdm
  module Models
    module User
      extend ActiveSupport::Concern

      included do
        
        validate :checkEmail

        def checkEmail
          errorMsg1 = ": the e-mail domain is not valid. Please note that you are signing up to the FIWARE Testbed, restricted to PPP members. If you are a PPP member, please use your corporate email (not gmail, yahoo, etc.). If you are not a PPP member, you can apply for an account in FIWARE Lab (http://lab.fi-ware.org/), that is suitable for anyone, PPP member or not.
                    If you are a PPP member using your corporate e-mail address and you get this message, please contact the support team at fiware-testbed-help@lists.fi-ware.org to add your domain name to our white list.
                    Important: a given domain on the white list authorises e-mail adresses in all the subdomains under it."

          errorMsg2 = ": you are using a forbidden e-mail domain in this project."

          emailDomain = Mail::Address.new(self.email).domain

          #If a blacklist if defined, all emails included can't be registered
          if FiWareIdm.forbidden_email_domains.present?
            if FiWareIdm.forbidden_email_domains.include?(emailDomain)
              errors.add(:email,errorMsg2)
              return
            end
          end

          #If a whitelist if defined, if a email is not included, it can't be registered
          if FiWareIdm.allowed_email_domains.present?
            if !FiWareIdm.allowed_email_domains.include?(emailDomain)
              errors.add(:email,errorMsg1)
              return
            end
          end

          true
        end

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

        #Allow to call can? method from model
        def ability
          @ability ||= Ability.new(self)
        end
        delegate :can?, :cannot?, :to => :ability
      end

      def admin?
        ((!Site.current.nil?) and (self.can? :update, Site.current))
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

        role_ids = options[:client].custom_roles.map(&:id)

        ties_hash.each_pair do |org, roles|
          hash['organizations'] << {
            id: org.subject.id,
            actorId: org.id,
            displayName: org.name,
            roles: roles.select{|r| role_ids.include? r.id}.map{ |r|
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
          #merge(::Relation.where(id: role_ids)).
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

      def api_attributes(current_user=nil)
        attrs = Hash.new
        attrs["id"] = self.id
        attrs["slug"] = self.slug
        attrs["name"] = self.name
        attrs["language"] = self.language
        if (current_user and (current_user.admin? or self.id==current_user.id))
          #Restricted data
          attrs["email"] = self.email
          attrs["authentication_token"] = self.authentication_token
        end
        attrs
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
            location: controller.root_url + "v2/users/" + actor.id.to_s
          },
          profileUrl: controller.root_url[0..-2] + controller.user_path(self),
          emails: [
            {
              value: email,
              primary: "true"
            }
          ],
          groups: self.organizations.map{ |o|
            {
              value: o.actor.id,
              ref: controller.root_url + "v2/organizations/" + o.actor.id.to_s,
              display: o.name
            }
          }
        }
      end
    end
  end
end
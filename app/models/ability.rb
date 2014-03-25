class Ability
  include SocialStream::Ability

  def initialize(subject)
    super

    if subject.is_a?(Application) && subject.store?
      can :create, Purchase
    end

    can :read, Relation::Purchaser

    can :manage, ::Permission::Custom do |p|
      subject.present? &&
       p.actor_id.present? && (
        p.actor_id == subject.actor_id ||
        p.actor.allow?(subject, 'manage', 'relation/custom')
      )
    end

    #SCIM2 Permissions
    # Pending. An Admin or SCIM Master role must be implemented.
    # can :manageSCIM, :all
    can :showSCIM, :all

  end
end

class Ability
  include SocialStream::Ability

  def initialize(subject)
    super

    admin = ((!subject.nil?) and (!Site.current.nil?) and (can? :update, Site.current))

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
    if admin
      can :showSCIM, :all
      can :manageSCIM, :all
    end

  end
end

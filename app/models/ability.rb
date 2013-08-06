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
  end
end

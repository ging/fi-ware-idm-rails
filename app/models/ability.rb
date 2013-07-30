class Ability
  include SocialStream::Ability

  def initialize(subject)
    super

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

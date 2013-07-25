class Ability
  include SocialStream::Ability

  def initialize(subject)
    super

    can :read, Relation::Purchaser
  end
end

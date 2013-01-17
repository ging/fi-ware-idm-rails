class Ability
  include SocialStream::Ability

  def initialize(subject)
    super

    # Add your authorization rules here
    # For instance:
    #    can :create, Comment
    #    can [:create, :destroy], Post do |p|
    #      p.actor_id == Actor.normalize_id(subject)
    #    end
  end
end
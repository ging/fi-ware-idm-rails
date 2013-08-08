class Application < Site::Client
  scope :granting_roles, ->(actor) {
    select("DISTINCT sites.*").
      joins(actor: :sent_permissions).
      merge(Contact.received_by(actor)).
      merge(Permission.where(action: 'get', object: 'relation/custom'))
  }

  scope :official, -> {
    where(official: true)
  }

  scope :purchased_by, ->(actor) {
    select("DISTINCT sites.*").
      joins(actor: :sent_relations).
      merge(Contact.received_by(actor)).
      merge(::Relation.where(id: ::Relation::Purchaser.instance.id))
  }

  def roles
    relations_list
  end

  def custom_roles
    relation_customs
  end

  # Adds a new purchaser of this application, which consists on
  # creating a new tie with Relation::Purchaser
  def add_purchaser!(actor)
    c = contact_to!(actor)
    c.relation_ids |= [ Relation::Purchaser.instance.id ]
  end

  def trigger_policy_save
    return unless FiWareIdm::Thales.enable

    XacmlPolicy.new self
  end

  def as_json(options = {})
    {
      id: id,
      name: name,
      description: description,
      url: url
    }
  end
end

class Application < Site::Client
  OFFICIAL = [ :cloud, :store, :mashup ]

  scope :granting_roles, ->(actor) {
    select("DISTINCT sites.*").
      joins(actor: :sent_permissions).
      merge(Contact.received_by(actor)).
      merge(Permission.where(action: 'get', object: 'relation/custom'))
  }

  scope :official, ->(type = nil) {
    if type.present?
      i = OFFICIAL.index(type)

      if i.present?
        where(official: i)
      else
        raise "Unknown official application #{ type.inspect }"
      end
    else
      where(arel_table[:official].not_eq(nil))
    end
  }

  scope :purchased_by, ->(actor) {
    select("DISTINCT sites.*").
      joins(actor: :sent_relations).
      merge(Contact.received_by(actor)).
      merge(::Relation.where(id: ::Relation::Purchaser.instance.id))
  }

  OFFICIAL.each do |app|
    define_method app do
      official == OFFICIAL.index(app)
    end

    alias_method "#{ app }?", app
  end

  def official?
    official.present?
  end

  def roles
    relations_list
  end

  def custom_roles
    relation_customs
  end

  def grants_roles?(subject)
    allow? subject, 'get', 'relation/custom'
  end

  # Adds a new purchaser of this application, which consists on
  # creating a new tie with Relation::Purchaser
  def add_purchaser!(actor)
    c = contact_to!(actor)
    c.relation_ids |= [ Relation::Purchaser.instance.id ]
  end

  def trigger_policy_save
    return unless FiWareIdm::Thales.enable

    XacmlPolicy.save self
  end

  def api_attributes
    attrs = self.attributes
    attrs["slug"] = self.slug
    attrs["name"] = self.name
    attrs
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

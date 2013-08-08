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

  def roles
    relations_list
  end

  def custom_roles
    relation_customs
  end

  def trigger_policy_save
    return unless FiWareIdm::Thales.enable

    XacmlPolicy.save self
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

class Application < Site::Client
  scope :granting_roles, ->(actor) {
    select("DISTINCT sites.*").
      joins(actor: :sent_permissions).
      merge(Contact.received_by(actor)).
      merge(Permission.where(action: 'get', object: 'relation/custom'))
  }

  def roles
    relations_list
  end

  def trigger_policy_save
    XacmlPolicy.new self
  end
end

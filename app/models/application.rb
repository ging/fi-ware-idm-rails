class Application < Site::Client
  def roles
    relations_list
  end

  def trigger_policy_save
    XacmlPolicy.new self
  end
end

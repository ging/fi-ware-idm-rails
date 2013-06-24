Actor.class_eval do
  def applications
    managed_site_clients
  end
end

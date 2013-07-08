class OrganizationsController < GroupsController
  # Change the settings of inherited_resources for organizations
  defaults resource_class: Organization

  def index
  end
end

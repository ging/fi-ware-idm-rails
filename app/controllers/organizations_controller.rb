class OrganizationsController < GroupsController
  # Change the settings of inherited_resources for organizations
  defaults resource_class: Organization

  before_filter :redirect_to_members, only: [ :index ]

  def index
  end

  private

  def redirect_to_members
    if current_subject.is_a? Organization
      redirect_to contacts_path
    end
  end
end

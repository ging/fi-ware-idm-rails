class OrganizationsController < GroupsController
  # Change the settings of inherited_resources for organizations
  defaults resource_class: Organization

  before_filter :redirect_to_members, only: [ :index ]

  def index
    if request.xhr?
      render partial: 'list',
             object: collection
    end
  end

  protected

  def end_of_association_chain
    chain =
      case params[:section]
      when 'others'
        current_user.other_organizations
      else
        current_user.organizations
      end

    chain.page(params[:page])
  end

  private

  def redirect_to_members
    if current_subject.is_a? Organization
      redirect_to contacts_path
    end
  end
end

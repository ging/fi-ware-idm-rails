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

  def collection
    get_collection_ivar ||
      set_collection_ivar(build_collection)
  end

  def build_collection
    col =
      case params[:section]
      when 'others'
        current_user.other_organizations
      else
        current_user.organizations
      end

    col.page(params[:page])
  end

  private

  def redirect_to_members
    if current_subject.is_a? Organization
      redirect_to contacts_path
    end
  end
end

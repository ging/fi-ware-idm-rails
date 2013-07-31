class Permission::CustomsController < InheritedResources::Base
  before_filter :authenticate_user!

  actions :create, :destroy

  load_and_authorize_resource class: Permission::Custom

  respond_to :js
end

class ApplicationsController < Site::ClientsController
  # Change the settings of inherited_resources for applications
  defaults resource_class: Application

  def index
    respond_to do |format|
      format.html
      format.json { render json: Actor.find(params[:actor_id]).applications }
    end
  end
end

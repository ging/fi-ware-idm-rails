class ApplicationsController < Site::ClientsController
  # Change the settings of inherited_resources for applications
  defaults resource_class: Application

  def index
    respond_to do |format|
      format.html {
        if request.xhr?
          render partial: 'list',
                 object: collection
        end
      }
      format.json { 
        if params[:actor_id]
          apps = Actor.find(params[:actor_id]).applications
        else
          apps = current_subject.applications.map{|a| a.api_attributes}
        end
        render json: apps
      }
    end
  end

  def create
    respond_to do |format|
      format.html {
        super
      }
      format.json {
        create! do |success, error|
          success.json { 
            render json: resource.api_attributes
          }
          error.json {
            render json: resource.errors
          }
        end
      }
    end
  end

  def show
    respond_to do |format|
      format.html {
        super
      }
      format.json {
        render json: resource.api_attributes
      }
    end
  end

  protected

  def build_collection
    case params[:section]
    when "purchased"
      current_subject.purchased_applications
    else
      current_subject.applications
    end
  end
end

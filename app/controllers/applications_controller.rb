class ApplicationsController < Site::ClientsController
  # Change the settings of inherited_resources for applications
  defaults resource_class: Application
  skip_load_and_authorize_resource :only => [:index_actors, :create_actor, :show_actor, :update_actor, :delete_actor]

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

  def update
    respond_to do |format|
      format.html {
        super
      }
      format.json {
        update! do |success, error|
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

  def destroy
    respond_to do |format|
      format.html {
        super
      }
      format.json {
        destroy! do |success, error|
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


  #Role Assignment. REST API

  #GET applications/#{app_slug}/actors.json
  def index_actors
    app = Application.find_by_slug(params[:app_id])
    respond_to do |format|
      format.any {
        render json: app.api_attributes({:includeRoles => app})
      }
    end
  end

  #POST applications/#{app_slug}/actors.json
  def create_actor
    app = Application.find_by_slug(params[:app_id])
    authorize! :update, app

    #1. Build parameters
    idmParams = Hash.new
    idmParams["actors"] = Actor.find_by_slug(params["actor_slug"]).id.to_s
    idmParams["relations"] = params["role_ids"].split(",")
    idmParams["application_id"] = app.id

    idmParams["auth_token"] = params["auth_token"]

    #2. Logic (Based on app/decorators/contacts_controller_decorator.rb, method create)
    relation_ids = idmParams["relations"].map(&:to_i)

    idmParams["actors"].split(',').each do |a|
      c = app.contact_to!(a)
      # Record who is manipulating the contact, mainly in groups
      c.user_author = current_user
      c.relation_ids = relation_ids
    end

    respond_to do |format|
      format.any {
        render json: app.api_attributes({:includeRoles => app})
      }
    end
  end

  #GET applications/#{app_slug}/actors/#{actor_slug}.json
  def show_actor
    app = Application.find_by_slug(params[:app_id])
    authorize! :show, app
    actor = app.actors.select{|a| a.slug==params[:actor_id]}.first
    if actor.nil?
      raise ActiveRecord::RecordNotFound
    end
    authorize! :show, actor.subject
    respond_to do |format|
      format.any {
        render json: actor.api_attributes({:includeRoles => app, :includeResources => false})
      }
    end
  end

  #PUT applications/#{app_slug}/actors/#{actor_slug}.json
  def update_actor
    app = Application.find_by_slug(params[:app_id])
    authorize! :update, app
    actor = app.actors.select{|a| a.slug==params[:actor_id]}.first
    if actor.nil?
      raise ActiveRecord::RecordNotFound
    end

    #1. Find the relation
    c = app.contact_to!(actor)
    #2. Update
    c.relation_ids = params["role_ids"].split(",").map(&:to_i)

    respond_to do |format|
      format.any {
        render json: actor.api_attributes({:includeRoles => app, :includeResources => false})
      }
    end
  end

  #DELETE applications/#{app_slug}/actors/#{actor_slug}.json
  def delete_actor
    app = Application.find_by_slug(params[:app_id])
    authorize! :update, app
    actor = app.actors.select{|a| a.slug==params[:actor_id]}.first
    if actor.nil?
      raise ActiveRecord::RecordNotFound
    end

    #1. Find the relation
    c = app.contact_to!(actor)
    #2. Remove roles
    c.relation_ids = []

    respond_to do |format|
      format.any {
        render json: actor.api_attributes({:includeRoles => app, :includeResources => false})
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

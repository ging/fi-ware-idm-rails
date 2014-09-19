class RolesController < ApplicationController
  before_filter :processParams

  def create
    r = Relation::Custom.new(params[:relation_custom])
    authorize! :create, r
    r.valid?

    respond_to do |format|
      format.json {
        if r.errors.blank? and r.save
          render json: r.api_attributes
        else
          render json: r.errors
        end
      }
    end
  end

  def show
    r = Relation.find(params[:id])
    authorize! :show, r

    respond_to do |format|
      format.json {
        render json: r.api_attributes
      }
    end
  end

  def update
    r = Relation::Custom.find(params[:id])
    authorize! :update, r

    r.update_attributes(params[:relation_custom])
    r.valid?

    respond_to do |format|
      format.json {
        if r.errors.blank? and r.save
          render json: r.api_attributes
        else
          render json: r.errors
        end
      }
    end
  end

  def destroy
    r = Relation::Custom.find(params[:id])
    authorize! :destroy, r

    r.destroy
    respond_to do |format|
      format.json {
        render json: r.api_attributes
      }
    end
  end

  private

  def processParams
    unless params[:role].nil?
      params[:relation_custom] = params[:role]
    end

    unless params[:relation_custom].nil?
      unless params[:relation_custom][:app_id].nil?
        params[:relation_custom][:actor_id] = Application.find(params[:relation_custom][:app_id]).actor_id
        params[:relation_custom].delete "app_id"
      end
      unless params[:relation_custom][:app_slug].nil?
        params[:relation_custom][:actor_id] = Application.find_by_slug(params[:relation_custom][:app_slug]).actor_id
        params[:relation_custom].delete "app_slug"
      end
    end
  end

end

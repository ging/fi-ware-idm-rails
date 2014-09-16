class UsersController < ApplicationController
  include SocialStream::Controllers::Subjects

  load_and_authorize_resource except: :current

  before_filter :authenticate_user!, only: :current

  respond_to :html, :xml, :js
  
  def index
    raise ActiveRecord::RecordNotFound
  end

  def show
    user = User.find_by_slug(params[:id])
    authorize! :read, user

    respond_to do |format|
      format.html {
        super
      }
      format.json { 
        render json: user.api_attributes(current_user), content_type: "application/json" 
      }
    end
  end

  def update
    user = User.find_by_slug(params[:id])
    authorize! :update, user

    user.assign_attributes(params[:user])
    user.valid?

    if user.errors.blank? and user.save
      render json: user.api_attributes(current_user), content_type: "application/json"
    else
      render json: user.errors, content_type: "application/json"
    end
  end

  def destroy
    user = User.find_by_slug(params[:id])
    authorize! :destroy, user

    if user.destroy
      render json: user.api_attributes(current_user), content_type: "application/json"
    else
      render json: "User could not be destroyed", content_type: "application/json"
    end
  end

  def current
    respond_to do |format|
      format.json { render json: current_user.to_json }
    end
  end

  # Supported through devise
  def new; end; def create; end
end

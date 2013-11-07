class NotificationsController < ApplicationController
  before_filter :authorize

  def new
    @notification = Notification.new
  end

  def create
    @notification = Notification.new params[:notification]

    if @notification.save
      flash[:success] = "Your notification has been sent successfully"

      redirect_to :home
    else
      render :new
    end
  end

  private

  def authorize
    authorize! :update, Site.current
  end
end

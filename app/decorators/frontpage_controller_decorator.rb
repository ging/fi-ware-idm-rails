FrontpageController.class_eval do
  before_filter :delete_redirect, only: :index

  def terms_of_service
  end

  private

  def delete_redirect
    session.delete("user_return_to")
  end
end

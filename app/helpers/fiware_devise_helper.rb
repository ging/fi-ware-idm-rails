module FiwareDeviseHelper
  def fiware_devise_error_messages!
    if resource.errors.present? &&
      resource.errors[:email] == ["not found"]
      "Sorry. You have specified an email address that is not registered to any our our user accounts. If your problem persits, please contact: fiware-lab-help@lists.fi-ware.org"
    else
      devise_error_messages!
    end
  end
end

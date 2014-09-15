module ApplicationHelper
  def active_official_app? name
    redirect_to_site_client? &&
      redirecting_site_client.send(name)
  end

  def active_official_app name
    active_official_app?(name) ?
      'active' :
      ''
  end

  def no_active_official_app?
    ! redirect_to_site_client? ||
      ! redirecting_site_client.official?
  end

  def no_active_official_app
    no_active_official_app? ?
      'active' :
      ''
  end

  def fiware_env_url(options = {})
    domain = FiWareIdm.subdomain

    if options[:subdomain].present?
      domain = "#{ options[:subdomain] }.#{ domain }"
    end

    protocol = 'http'

    if options[:https].present?
      protocol += 's'
    end

    "#{ protocol }://#{ domain }"
  end

  def isAdmin?
    user_signed_in? and current_user.admin?
  end

  #Inherited from Social Stream
  def current_subject_contacts_to(contacts)
    contacts.map{ |c|
      current_actor.blank? || c.sender == current_actor ?
        c :
        current_actor.contact_to!(c.receiver)
    }
  end

  def current_subject_contacts(subject)
    params[:subject] = subject
    params[:d]    ||= 'sent'
    params[:type] ||= subject.class.contact_index_models.first.to_s
    current_subject_contacts_to(Contact.index(params))
  end

  def administrators_list
    params[:subject] = Site.current
    params[:d]    ||= 'sent'
    params[:type] ||= 'user'
    Contact.index(params)
  end
  
end

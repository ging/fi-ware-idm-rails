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

  def include_shibbolet_idp
    # For SSO IDP side
    script = "<script>var idp_logout_url ="
    if user_signed_in? and current_user.ext_idp?
      script += "'" + ExternalIdp.find(current_user.ext_idp).url + "/idp/profile/Logout'";
    else
      script += "''"
    end
    script += "</script>"
    script.html_safe
  end
  
end

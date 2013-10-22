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

  def no_active_official_app
    ! redirect_to_site_client? ||
      ! redirecting_site_client.official?
  end

  def fiware_env_url(options = {})
    domain = request.host.gsub(/\Aaccount\./, '')

    if options[:subdomain].present?
      domain = "#{ options[:subdomain] }.#{ domain }"
    end

    protocol = 'http'

    if options[:https].present?
      protocol += 's'
    end

    "#{ protocol }://#{ domain }"
  end
end

module ApplicationHelper
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

class XacmlPolicy
  require 'rest_client'

  ErrorMessage = "Put XACML policy file to Access Control GE failed!"
  #require 'xacml_file'
  # Create a new XACML Policy
  # The application has available the following methods
  #
  #   application.roles #=> list of roles
  #
  #   role = application.roles.first
  #
  #   role.permissions #=> list of permissions per role
  #
  
  class << self
    def save(application)
      new(application)
    end
  end

  def initialize(application)

    puts '*' * 30
    puts "Application.name = "+application.name
  
    create_XACML(application)  
  end

  def create_XACML(application)

    xacml = XacmlFile.new
    xml = xacml.create_XACMLpolicy application

    ##print xml file
    #puts xml.to_xml

    put_request xml
  end

  def put_request(xml)
    
    p12 = OpenSSL::PKCS12.new(File.read(FiWareIdm::Thales.key), FiWareIdm::Thales.passphrase)
    certificate = OpenSSL::X509::Certificate.new(File.read(FiWareIdm::Thales.client_certificate))
 
    client = RestClient::Resource.new(FiWareIdm::Thales.url, 
      :ssl_client_cert => certificate,
      :ssl_client_key => p12.key,
      :verify_ssl => OpenSSL::SSL::VERIFY_PEER,
      :ssl_ca_file => FiWareIdm::Thales.ca_certificate)

    begin
      response = client.put(xml.to_xml, :content_type =>"application/xml")
    rescue RestClient::BadRequest => e
      raise "#{ ErrorMessage } #{ e.response }"
    end

    raise "#{ ErrorMessage } #{ response.body }" if response.code !=200

    logger.info "XACML Policy successfully saved!"
  end
end

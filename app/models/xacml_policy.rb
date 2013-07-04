class XacmlPolicy
  # Create a new XACML Policy
  # The application has available the following methods
  #
  #   application.roles #=> list of roles
  #
  #   role = application.roles.first
  #
  #   role.permissions #=> list of permissions per role
  #
  #
  def initialize(application)
    puts '*' * 30
    puts 'saving policy'
    puts "role list: #{ application.roles.map(&:name) }"
    puts '*' * 30
  end
end

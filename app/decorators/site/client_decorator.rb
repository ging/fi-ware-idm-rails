require_dependency 'fi_ware_idm/models/site/client'
require_dependency 'site/client'

Site::Client.class_eval do
  include FiWareIdm::Models::Site::Client
end

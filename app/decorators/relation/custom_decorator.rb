require_dependency 'relation/custom'
require_dependency 'fi_ware_idm/models/relation/custom'

Relation::Custom.class_eval do
  include FiWareIdm::Models::Relation::Custom
end

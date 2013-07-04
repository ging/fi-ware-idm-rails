require_dependency 'relation_permission'
require_dependency 'fi_ware_idm/models/relation_permission'

RelationPermission.class_eval do
  include FiWareIdm::Models::RelationPermission
end

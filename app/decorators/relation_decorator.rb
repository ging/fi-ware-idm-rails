require_dependency 'fi_ware_idm/models/relation'
require_dependency 'relation'

Relation.class_eval do
  include FiWareIdm::Models::Relation
end

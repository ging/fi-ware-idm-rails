require_dependency 'fi_ware_idm/models/actor'

Actor.class_eval do
  include FiWareIdm::Models::Actor
end

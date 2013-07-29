require_dependency 'fi_ware_idm/models/tie'

Tie.class_eval do
  include FiWareIdm::Models::Tie
end

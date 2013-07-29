require_dependency 'fi_ware_idm/models/user'

User.send :include, FiWareIdm::Models::User

require_dependency 'fi_ware_idm/controllers/avatars'

AvatarsController.send :include, FiWareIdm::Controllers::Avatars

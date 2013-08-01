require 'fi_ware_idm/controllers/profiles'

ProfilesController.send :include, FiWareIdm::Controllers::Profiles

require_dependency 'fi_ware_idm/controllers/contacts'

ContactsController.send :include, FiWareIdm::Controllers::Contacts

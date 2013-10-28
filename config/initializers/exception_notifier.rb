if Rails.env == 'production'
  require_dependency 'fi_ware_idm'

  FiWareIdm::Application.configure do
    config.middleware.use ExceptionNotifier,
      email_prefix: "[IdM Error] ",
      sender_address: %{"Error Notifier" <#{ FiWareIdm.sender }>},
      exception_recipients: FiWareIdm.bug_receivers
  end
end

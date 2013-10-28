require_dependency 'fi_ware_idm'

# Turn off auto TLS for e-mail
ActionMailer::Base.default_url_options[:host] = FiWareIdm.domain
ActionMailer::Base.smtp_settings[:enable_starttls_auto] = false


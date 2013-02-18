# Turn off auto TLS for e-mail
ActionMailer::Base.default_url_options[:host] = 'idm.lab.fi-ware.eu'
ActionMailer::Base.smtp_settings[:enable_starttls_auto] = false


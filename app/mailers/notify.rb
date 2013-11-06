class Notify < ActionMailer::Base
  default from: FiWareIdm.sender

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notify.all.subject
  #
  def all receiver, subject, body
    @body = body

    mail to: receiver, subject: "[#{ FiWareIdm.name }] #{ subject }"
  end
end

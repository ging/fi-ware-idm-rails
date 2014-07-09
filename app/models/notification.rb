class Notification < ActiveRecord::Base
  validates :subject, :body, presence: true

  before_create :purgeBody
  after_create :send_emails

  private

  def purgeBody
  	#Prevent text styling to be sent together with the text
  	#This usually occurs when text is copied from text editors such as Microsoft Word

    # self.body = Sanitize.clean(self.body,Sanitize::Config::RESTRICTED)
    # Sanitize::Config::BASIC more flexible. For instance, allows <a> links and lists.
    customSanitizeConfig = Sanitize::Config::BASIC

    # Allow font tags with size attributtes
    # customSanitizeConfig[:elements].push("font")
    # customSanitizeConfig[:attributes]["font"] = ["size"]

    self.body = Sanitize.clean(self.body,customSanitizeConfig)
  	self.body = self.body.gsub(/(^[\r\n]+)/, "")
  	self.body = self.body.gsub(/([.]*[\r\n]+)/, "\r\n")
  end

  def send_emails
  	User.where("confirmed_at IS NOT NULL").each do |u|
      Notify.all(u.email, subject, body).deliver
    end
  end

end

class Notification < ActiveRecord::Base
  validates :subject, :body, presence: true

  after_create :send_emails

  private

  def send_emails
  	User.where("confirmed_at IS NOT NULL").each do |u|
      Notify.all(u.email, subject, body).deliver
    end
  end
end

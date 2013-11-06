class Notification < ActiveRecord::Base
  validates :subject, :body, presence: true

  after_create :send_email

  private

  def send_email

  end
end

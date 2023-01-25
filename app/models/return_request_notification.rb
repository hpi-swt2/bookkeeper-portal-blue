# class of a basic return request notification.
class ReturnRequestNotification < ApplicationRecord
  acts_as :notification

  belongs_to :borrower, class_name: "User"
  belongs_to :item

  validates :receiver, presence: true
  validates :date, presence: true
  after_create :send_mail

  def title
    I18n.t "views.notifications.return_request.title"
  end

  def description
    I18n.t "views.notifications.return_request.description", receiver: borrower.name, item: item.name
  end
end

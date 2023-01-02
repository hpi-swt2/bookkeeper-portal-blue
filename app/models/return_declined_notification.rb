# class of a basic return declined notification.
class ReturnDeclinedNotification < ApplicationRecord
  acts_as :notification

  belongs_to :borrower, class_name: "User"
  belongs_to :item

  validates :user, presence: true
  validates :date, presence: true

  def title
    I18n.t "views.notifications.return_declined.title"
  end

  def description
    I18n.t "views.notifications.return_declined.description", user: borrower.name, item: item.name
  end
end

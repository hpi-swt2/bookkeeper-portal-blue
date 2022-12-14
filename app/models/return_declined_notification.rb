# class of a basic return declined notification.
class ReturnDeclinedNotification < ApplicationRecord
  acts_as :notification

  belongs_to :owner, class_name: "User"

  validates :receiver, presence: true
  validates :date, presence: true
  validates :item_name, presence: true

  def title
    I18n.t "views.notifications.return_declined.title"
  end

  def description
    I18n.t "views.notifications.return_declined.description", owner: owner.name, item: item_name
  end
end

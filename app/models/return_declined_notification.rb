# class of a basic return declined notification.
class ReturnDeclinedNotification < ApplicationRecord
  acts_as :notification

  # belongs_to :owner, class_name: "User"
  belongs_to :item

  validates :receiver, presence: true
  validates :date, presence: true

  def title
    I18n.t "views.notifications.return_declined.title", item: item.name
  end

  def description
    I18n.t "views.notifications.return_declined.description", owner: item.owning_user.name, item: item.name
  end
end

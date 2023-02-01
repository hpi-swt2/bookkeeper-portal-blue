# class of a basic return accepted notification.
class ReturnAcceptedNotification < ApplicationRecord
  acts_as :notification

  #belongs_to :owner, class_name: "User"
  belongs_to :item

  validates :receiver, presence: true
  validates :date, presence: true

  def title
    I18n.t "views.notifications.return_accepted.title"
  end

  def description
    I18n.t "views.notifications.return_accepted.description", owner: item.owning_user.name, item: item.name
  end
end



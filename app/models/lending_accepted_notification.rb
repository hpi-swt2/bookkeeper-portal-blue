# This class defines the specific lending accepted notification, a notification
# that additionally belongs to a borrower and an item.
class LendingAcceptedNotification < ApplicationRecord
  acts_as :notification

  belongs_to :borrower, class_name: "User"
  belongs_to :item

  def title
    I18n.t "views.notifications.LendingAccepted.title"
  end

  def description
    I18n.t "views.notifications.LendingAccepted.description"
  end
end

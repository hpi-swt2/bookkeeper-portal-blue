# This class defines the specific lend request notification, a notification
# that additionally belongs to a borrower and an item. The custom partial
# HTML defines an accept and a decline button
class LendRequestNotification < ApplicationRecord
  acts_as :notification

  belongs_to :borrower, class_name: "User"
  belongs_to :item

  def title
    I18n.t "views.notifications.lend_request.title"
  end

  def description
    I18n.t "views.notifications.lend_request.description", user: borrower.name, item: item.name
  end
end

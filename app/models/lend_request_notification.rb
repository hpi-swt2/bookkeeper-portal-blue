# This class defines the specific lend request notification, a notification
# that additionally belongs to a borrower and an item. The custom partial
# HTML defines an accept and a decline button
# Class specifically for lending request notifications
class LendRequestNotification < ApplicationRecord
  acts_as :notification

  belongs_to :borrower, class_name: "User"
  belongs_to :item
  after_create :send_mail

  def title
    I18n.t "views.notifications.lend_request.title", item: item.name
  end

  def set_accepted
    update(accepted: true)
  end

  def set_denied
    update(accepted: false)
  end

  def description
    user_name = borrower.name
    item_name = item.name
    if active
      I18n.t "views.notifications.lend_request.description", receiver: user_name, item: item_name
    elsif accepted
      I18n.t "views.notifications.lend_request.description_accepted", receiver: user_name, item: item_name
    else
      I18n.t "views.notifications.lend_request.description_declined", receiver: user_name, item: item_name
    end
  end
end

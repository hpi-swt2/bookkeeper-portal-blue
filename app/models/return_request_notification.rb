# class of a basic return request notification.
class ReturnRequestNotification < ApplicationRecord
  acts_as :notification

  belongs_to :borrower, class_name: "User"
  belongs_to :item

  validates :receiver, presence: true
  validates :date, presence: true

  def set_accepted
    update(accepted: true)
  end

  def set_denied
    update(accepted: false)
  end

  def title
    I18n.t "views.notifications.return_request.title"
  end

  def description
    user_name = borrower.name
    item_name = item.name
    if active
      I18n.t "views.notifications.return_request.description", receiver: borrower.name, item: item.name
    elsif accepted
      I18n.t "views.notifications.return_request.description_accepted", receiver: user_name, item: item_name
    else
      I18n.t "views.notifications.return_request.description_declined", receiver: user_name, item: item_name
    end
  end
end

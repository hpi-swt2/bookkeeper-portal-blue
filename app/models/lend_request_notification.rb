# Class specifically for lending request notifications
class LendRequestNotification < ApplicationRecord
  acts_as :notification

  belongs_to :borrower, class_name: "User"
  belongs_to :item

  def title
    I18n.t "views.notifications.lend_request.title"
  end

  def description
    if active 
      I18n.t "views.notifications.lend_request.description", user: borrower.name, item: item.name
    else 
      if accepted
        "You have lent #{item.name} to #{borrower.name}"
      else 
        "You have declined to lent #{item.name} to #{borrower.name}"
      end
    end
  end
end

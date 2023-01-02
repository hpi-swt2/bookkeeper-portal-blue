# class of a basic return accepted notification.
class ReturnAcceptedNotification < ApplicationRecord
    acts_as :notification
  
    belongs_to :borrower, class_name: "User"
    belongs_to :item
  
    validates :user, presence: true
    validates :date, presence: true
  
    def title
      I18n.t "views.notifications.return_accepted.title"
    end
  
    def description
      I18n.t "views.notifications.return_accepted.description", user: borrower.name, item: item.name
    end
  end
  
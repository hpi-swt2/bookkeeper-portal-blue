class ReturnRequestNotification < ApplicationRecord
  acts_as :notification

  belongs_to :borrower, class_name: "User"
  belongs_to :item

  validates :user, presence: true
  validates :date, presence: true
  validates :item, presence: true
  validates :borrower, presence: true

  def title
    I18n.t "views.notifications.return_request.title"
  end

  def description
    I18n.t "views.notifications.return_request.description", user: borrower.name, item: item.name
  end
end

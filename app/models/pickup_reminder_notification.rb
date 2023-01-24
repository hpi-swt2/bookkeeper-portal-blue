class PickupReminderNotification < ApplicationRecord
  acts_as :notification

  belongs_to :item

  def title
    I18n.t "views.notifications.pickupreminder.title"
  end

  def description
    I18n.t "views.notifications.pickupreminder.description", item: item.name
  end
end


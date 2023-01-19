# This class defines the specific lending accepted notification, a notification
# that additionally belongs to a borrower and an item.
class LendingAcceptedNotification < ApplicationRecord
  acts_as :notification

  belongs_to :item

  def title
    I18n.t "views.notifications.lending_accepted.title"
  end

  def description
    owner = item.owning_user.nil? item.owning_group : item.owning_user
    I18n.t "views.notifications.lending_accepted.description", owner: owner.name, item: item.name
  end
end

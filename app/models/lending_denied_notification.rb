# This class defines the specific lending denied notification, a notification
# that additionally belongs to a borrower and an item.
class LendingDeniedNotification < ApplicationRecord
  acts_as :notification

  belongs_to :item

  def title
    I18n.t "views.notifications.lending_denied.title"
  end

  def description
    owner = item.owning_user.nil? item.owning_group : item.owning_user
    I18n.t "views.notifications.lending_denied.description", owner: owner.name, item: item.name
  end
end

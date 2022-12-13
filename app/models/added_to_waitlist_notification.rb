class AddedToWaitlistNotification < ApplicationRecord
  acts_as :notification

  belongs_to :item

  def title
    I18n.t("views.notifications.added_to_waitlist.title")
  end

  def description
    I18n.t("views.notifications.added_to_waitlist.description", position: item.waitlist.position(user) + 1,
                                                                item: item.name)
  end
end

# class of a notification send to user, when position in a waitlist changes.
class MoveUpOnWaitlistNotification < ApplicationRecord
  acts_as :notification

  belongs_to :item

  def title
    I18n.t("views.notifications.move_up_on_waitlist.title")
  end

  def description
    I18n.t("views.notifications.move_up_on_waitlist.description", position: item.waitlist.position(user) + 1,
                                                                  item: item.name)
  end
end

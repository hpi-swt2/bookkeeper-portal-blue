# class of a notification send to user, when position in a waitlist changes.
class MoveUpOnWaitlistNotification < ApplicationRecord
  acts_as :notification

  belongs_to :item

  after_create :check_position

  def title
    I18n.t "views.notifications.move_up_on_waitlist.title", item: item.name
  end

  def description
    I18n.t("views.notifications.move_up_on_waitlist.description", position: item.waitlist.position(receiver) + 1,
                                                                  item: item.name)
  end

  def check_position
    return unless item.waitlist.position(receiver).zero?

    send_mail
  end
end

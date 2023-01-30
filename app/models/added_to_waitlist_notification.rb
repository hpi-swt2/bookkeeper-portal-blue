# class of a notification send to user, when he/her has been added to a waitlist.
class AddedToWaitlistNotification < ApplicationRecord
  acts_as :notification

  belongs_to :item

  def title
    I18n.t "views.notifications.added_to_waitlist.title",  item: item.name
  end

  def description
    I18n.t "views.notifications.added_to_waitlist.description", position: item.waitlist.position(receiver) + 1,
                                                                item: item.name
  end
end

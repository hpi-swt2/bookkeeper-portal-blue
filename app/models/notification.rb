# Super-class to hold information about all Notifications
# This actable (i.e. abstract) class is designed to be the superclass of all
# specific types of notifications. It is responsible for some very basic functionality
# and delegating missing methods to the specific notification subclass.
class Notification < ApplicationRecord
  actable

  belongs_to :user

  def custom_partial
    specific.class.name.underscore
  end

  def mark_as_read
    update(unread: false)
  end

  # parse the time scheme for the notification
  def parse_time
    time = date
    if time.today?
      time.strftime('%H:%M')
    elsif time.yesterday?
      I18n.t 'views.notifications.timestamp_yesterday'
    elsif Date.today - 6.days <= time
      day = time.strftime('%A')
      I18n.t "views.notifications.timestamp_#{day}"
    else
      time.strftime('%d/%m/%Y')
    end
  end

  # delegate methods from the "subclasses" (which aren't really subclasses)
  # to the specific instances
  def method_missing(method, *args, &block)
    if specific.self_respond_to?(method)
      specific.send(method, *args, &block)
    else
      super
    end
  end

  def respond_to_missing?(_method, _include_private = false)
    false
  end
end

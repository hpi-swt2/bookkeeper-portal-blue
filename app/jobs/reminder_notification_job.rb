class ReminderNotificationJob < ApplicationJob
  queue_as :default

  def perform(item)
    item.perform_pickup_check
  end
end

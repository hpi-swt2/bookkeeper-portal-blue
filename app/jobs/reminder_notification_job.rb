class ReminderNotificationJob < ApplicationJob
  queue_as :default

  def perform(job)
    job.item.perform_pickup_check
  end
end

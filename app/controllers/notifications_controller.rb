class NotificationsController < ApplicationController
  before_action :authenticate_user!
  def index
    fetch_active_notification
    fetch_inactive_notifications
  end

  def fetch_active_notification
    @active_notifications = Notification.where(active: true, receiver_id: current_user.id)
    @active_dates = @active_notifications.group_by do |notification|
      notification.date.strftime('%y%m%d')
    end
    @active_dates = @active_dates.sort_by { |date, _| date }.reverse
  end

  def fetch_inactive_notifications
    @inactive_notifications = Notification.where(active: false, receiver_id: current_user.id)
    @inactive_dates = @inactive_notifications.group_by do |notification|
      notification.date.strftime('%y%m%d')
    end
    @inactive_dates = @inactive_dates.sort_by { |date, _| date }.reverse
  end

  def show
    @notification = Notification.find(params[:id])
    @notification.update(unread: false)
  end

  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy

    redirect_to notifications_path
  end

  def accept
    @notification = Notification.find(params[:id])
    @notification.mark_as_read
    @notification.mark_as_inactive
    @notification.set_accepted
    @item = @notification.item
    accept_item
    LendingAcceptedNotification.create(item: @item, receiver: @notification.borrower, date: Time.zone.now,
                                       active: false, unread: true)
    redirect_to notifications_path
  end

  def decline
    @notification = Notification.find(params[:id])
    @notification.mark_as_read
    @notification.mark_as_inactive
    @notification.set_denied
    @item = @notification.item
    @item.set_status_available
    @item.save
    LendingDeniedNotification.create(item: @item, receiver: @notification.borrower, date: Time.zone.now,
                                     active: false, unread: true)
    redirect_to notifications_path
  end

  private

  def accept_item
    @item.set_status_pending_pickup
    @job = Job.create
    @job.item = @item
    @job.save
    ReminderNotificationJob.set(wait: 4.days).perform_later(@job)
    @item.set_rental_start_time
    @item.update(holder: @notification.borrower.id)
    @item.save
    helpers.audit_accept_lend(@item)
  end
end

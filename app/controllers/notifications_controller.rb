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
    @notification.update(active: false)
    @lendrequest = LendRequestNotification.find(@notification.actable_id)
    @lendrequest.update(accepted: true)
    redirect_to notifications_path
  end

  def decline
    @notification = Notification.find(params[:id])
    @notification.update(active: false)
    @lendrequest = LendRequestNotification.find(@notification.actable_id)
    @lendrequest.update(accepted: false)
    redirect_to notifications_path
  end
end

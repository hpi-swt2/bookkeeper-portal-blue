class NotificationsController < ApplicationController
  before_action :authenticate_user!
  def index
    @active_notifications= Notification.where(active: true, user_id: current_user.id)
    @active_dates = @active_notifications.group_by do |notification|
      notification.date.strftime('%y%m%d')
    end
    @active_dates = @active_dates.sort_by { |date, _| date }.reverse

    @inactive_notifications= Notification.where(active: false, user_id: current_user.id)
    @inactive_dates = @inactive_notifications.group_by do |notification|
      notification.date.strftime('%y%m%d')
    end
    @inactive_dates = @inactive_dates.sort_by { |date, _| date }.reverse

  end

  def show
    @notification = Notification.find(params[:id])
  end
end

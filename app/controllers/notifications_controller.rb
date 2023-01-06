class NotificationsController < ApplicationController
  before_action :authenticate_user!
  def index
    @notifications = Notification.where(user_id: current_user.id)
    @dates = @notifications.group_by do |notification|
      notification.date.strftime('%d. %B %y')
    end
    @dates = @dates.sort_by { |date, _| date }.reverse
  end
end

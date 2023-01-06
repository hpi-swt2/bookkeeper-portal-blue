class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    @user = current_user
    fetch_notifications_size
  end

  def fetch_notifications_size
    @notifications_size = Notification.where(active: true, receiver_id: current_user.id).size
  end
end

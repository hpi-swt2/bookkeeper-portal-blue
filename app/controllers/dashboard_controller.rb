class DashboardController < ApplicationController
  def index
    @user = current_user
    @unread_notifications_num = 0
  end
end

class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    @user = current_user
    @unread_notifications_num = 0
  end
end

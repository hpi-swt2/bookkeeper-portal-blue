class LandingPageController < ApplicationController
  before_action :authenticate_user!

  def index
    redirect_to dashboard_path
  end
end

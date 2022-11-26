class ApplicationController < ActionController::Base
  before_action :set_nav

  def set_nav
    @nav = [
      { text: "Home", path: dashboard_path, icon: "bi bi-house-door" },
      { text: "Search", path: search_path, icon: "bi bi-search" },
      { text: "New Item", path: new_item_path, icon: "bi bi-plus-square" },
      { text: "Notifications", path: notifications_path, icon: "bi bi-bell" },
      { text: "Profile", path: profile_path, icon: "bi bi-person" }
    ]
  end
end

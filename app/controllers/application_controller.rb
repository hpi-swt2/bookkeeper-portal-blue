class ApplicationController < ActionController::Base
  before_action :set_nav

  def set_nav
    @nav = [
      { text: "Home", path: "#", icon: "bi bi-house-door" },
      { text: "Search", path: "#", icon: "bi bi-search" },
      { text: "New Item", path: "#", icon: "bi bi-plus-square" },
      { text: "Notifications", path: "notifications", icon: "bi bi-bell" },
      { text: "Profile", path: "#", icon: "bi bi-person" }
    ]
  end
end

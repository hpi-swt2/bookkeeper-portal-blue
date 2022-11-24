class ApplicationController < ActionController::Base
  before_action :set_nav

  def set_nav
    @nav = [
      { text: "Home", path: "#", icon: "bi bi-house-door" },
      { text: "Search", path: "#", icon: "bi bi-search" },
      { text: "New Item", path: "#", icon: "bi bi-plus-square" },
      { text: "Notifications", path: "#", icon: "bi bi-bell" },
      { text: "Profile", path: "#", icon: "bi bi-person" }
    ]
  end

  around_action :switch_locale

  def switch_locale(&action)
    locale = extract_locale_from_header
    I18n.with_locale(locale, &action)
  end

  private

  def extract_locale_from_header
    parsed_locale = request.headers['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    if I18n.locale_available?(parsed_locale)
      parsed_locale
    else
      I18n.default_locale
    end
  rescue StandardError
    I18n.default_locale
  end
end

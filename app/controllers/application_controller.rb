class ApplicationController < ActionController::Base
  before_action :set_nav

  def set_nav
    @nav = [
      { text: t("views.home.title"), path: dashboard_path, icon: "bi bi-house-door" },
      { text: t("views.search.title"), path: search_path, icon: "bi bi-search" },
      { text: t("views.new_item.title"), path: new_item_path, icon: "bi bi-plus-square" },
      { text: t("views.notifications.title"), path: notifications_path, icon: "bi bi-bell" },
      { text: t("views.profile.title"), path: profile_path, icon: "bi bi-person" }
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

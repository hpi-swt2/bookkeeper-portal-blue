class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action :set_nav

  def set_nav
    @nav = [
      { text: "views.dashboard.title", path: dashboard_path, icon: "bi bi-house-door" },
      { text: "views.search.title", path: search_path, icon: "bi bi-search" },
      { text: "views.new_item.title", path: new_item_path, icon: "bi bi-plus-square" },
      { text: "views.notifications.title", path: notifications_path, icon: "bi bi-bell" },
      { text: "views.profile.title", path: profile_path, icon: "bi bi-person" }
    ]
  end

  private

  def default_url_options
    { locale: I18n.locale }
  end

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end
end

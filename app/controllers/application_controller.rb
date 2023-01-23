class ApplicationController < ActionController::Base
  before_action :set_nav
  before_action :set_locale

  def set_nav
    @nav = [
      { text: "views.dashboard.title", path: dashboard_path, icon: "bi bi-house-door" },
      { text: "views.search.title", path: search_path, icon: "bi bi-search" },
      { text: "views.new_item.title", path: new_item_path, icon: "bi bi-plus-square" },
      { text: "views.notifications.title", path: notifications_path, icon: "bi bi-bell" },
      { text: "views.profile.title", path: profile_path, icon: "bi bi-person" }
    ]
  end

  # around_action :switch_locale

  # def switch_locale(&action)
  #   locale = extract_locale_from_header
  #   I18n.with_locale(locale, &action)
  # end

  private

  # def extract_locale_from_header
  #   parsed_locale = request.headers['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  #   if I18n.locale_available?(parsed_locale)
  #     parsed_locale
  #   else
  #     I18n.default_locale
  #   end
  # rescue StandardError
  #   I18n.default_locale
  # end

  def default_url_options
    { locale: I18n.locale == I18n.default_locale ? nil : I18n.locale }
  end

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale.to_sym : nil
  end

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end
end

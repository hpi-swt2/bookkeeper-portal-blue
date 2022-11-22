class ApplicationController < ActionController::Base
  around_action :switch_locale

  def switch_locale(&action)
    locale = extract_locale_from_header
    if I18n.locale_available?(locale)
      I18n.with_locale(locale, &action)
      logger.debug "* Locale set to '#{locale}'"
    else
      I18n.with_locale(I18n.default_locale, &action)
    end
  end

  private
  def extract_locale_from_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end
end

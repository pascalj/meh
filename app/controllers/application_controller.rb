class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale

  def set_locale
    I18n.locale = extract_locale_from_accept_language_header
  end

  private

  def extract_locale_from_accept_language_header
    return I18n.default_locale if request.env['HTTP_ACCEPT_LANGUAGE'].nil?
    locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
    if I18n.available_locales.include?(locale.to_sym)
      locale
    else
      I18n.default_locale
    end
  end
end

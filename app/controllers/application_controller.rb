class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :bio, :email, :is_admin, :provider, :uid, :avatar])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:first_name, :last_name, :bio, :email, :is_admin, :provider, :uid, :avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :bio, :email, :is_admin, :provider, :uid, :avatar])
  end

  def set_locale
    if cookies[:lang] && I18n.available_locales.include?(cookies[:lang].to_s.strip.to_sym)
      lang = cookies[:lang].to_s.strip.to_sym
    else
      lang = current_user.try(:setting).try(:default_locale) || I18n.default_locale
      cookies[:lang] = lang
    end
    I18n.locale = lang
  end

  def set_dark_mode(dark_mode: false)
    cookies[:dark_mode] = dark_mode.to_s
  end
end

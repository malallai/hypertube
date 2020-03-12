class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :masquerade_user!
  before_action :set_locale

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :username, :email, :avatar, :local])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :username, :email, :avatar, :local])
  end

  private
  def set_locale
    if user_signed_in?
      if ['en', 'fr'].include? current_user.local
        I18n.locale = current_user.local
      else
        I18n.locale = I18n.default_locale
      end
      session[:locale] = I18n.locale
    elsif !session[:locale].nil?
      I18n.locale = session[:locale]
    else
      I18n.locale = I18n.default_locale
      session[:locale] = I18n.locale
    end
    Tmdb::Api.language(session[:locale])
  end
end

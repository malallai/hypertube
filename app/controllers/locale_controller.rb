class LocaleController < ApplicationController

  def change_locale
    if user_signed_in?
      current_user.local = params[:locale]
      current_user.save
    else
      session[:locale] = params[:locale]
    end
  end

end

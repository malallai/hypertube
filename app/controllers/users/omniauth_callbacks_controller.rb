module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    before_action :set_service
    before_action :set_user, only: :marvin
    before_action :set_user_discord, only: :discord

    attr_reader :service, :user

    def discord
      handle_auth_discord "Discord"
    end

    def marvin
      handle_auth "42"
    end

    private

    def handle_auth(kind)
      if service.present?
        service.update(service_attrs)
      else
        if user.save
          user.services.create(service_attrs)
        end
      end

      if user_signed_in?
        flash[:notice] = "Your #{kind} account was connected."
        redirect_to edit_user_registration_path
      else
        sign_in_and_redirect user, event: :authentication
        set_flash_message :notice, :success, kind: kind
      end
    end

    def handle_auth_discord(kind)
      if service.present?
        service.update(service_attrs)
      else
        if user.save
          user.services.create(service_attrs)
        end
      end

      if user_signed_in?
        flash[:notice] = "Your #{kind} account was connected."
        redirect_to edit_user_registration_path
      else
        sign_in_and_redirect user, event: :authentication
        set_flash_message :notice, :success, kind: kind
      end
    end

    def auth
      request.env['omniauth.auth']
    end

    def set_service
      if !params['error'].nil?
        redirect_to(new_user_session_path, alert: t('devise.omniauth_callbacks.failure', :reason => params['error_description']))
      else
        @service = Service.where(provider: auth.provider, uid: auth.uid).first
      end
    end

    def set_user
      if user_signed_in?
        @user = current_user
      elsif service.present?
        @user = service.user
      elsif User.where(email: auth.info.email).any?
        # 5. User is logged out and they login to a new account which doesn't match their old one
        flash[:alert] = "An account with this email already exists. Please sign in with that account before connecting your #{auth.provider.titleize} account."
        redirect_to new_user_session_path
      else
        @user = create_user
      end
    end

    def set_user_discord
      if user_signed_in?
        @user = current_user
      elsif service.present?
        @user = service.user
      elsif User.where(email: auth.info.email).any?
        # 5. User is logged out and they login to a new account which doesn't match their old one
        flash[:alert] = "An account with this email already exists. Please sign in with that account before connecting your #{auth.provider.titleize} account."
        redirect_to new_user_session_path
      elsif User.where(username: auth.extra.raw_info.username + '#' + auth.extra.raw_info.discriminator).any?
        flash[:alert] = "An account with this username already exists. Please sign in with that account before connecting your #{auth.provider.titleize} account."
        redirect_to new_user_session_path
      else
        @user = create_user_discord
      end
    end

    def service_attrs
      expires_at = auth.credentials.expires_at.present? ? Time.at(auth.credentials.expires_at) : nil
      {
          provider: auth.provider,
          uid: auth.uid,
          expires_at: expires_at,
          access_token: auth.credentials.token,
          access_token_secret: auth.credentials.secret,
      }
    end

    def create_user
      fullname = auth.info.name.split(' ')
      user = User.create(
          email: auth.info.email,
          username: auth.info.nickname,
          first_name: fullname[0],
          last_name: fullname[1],
          password: Devise.friendly_token[0,20]
      )
      image = open(auth.info.image)
      user.avatar.attach(io: image, filename: 'avatar.jpg', content_type: image.content_type)
      user.save
      user
    end

    def create_user_discord
      user = User.create(
          email: auth.info.email,
          username: auth.extra.raw_info.username + '#' + auth.extra.raw_info.discriminator,
          first_name: auth.extra.raw_info.username,
          last_name: auth.extra.raw_info.discriminator,
          password: Devise.friendly_token[0,20]
      )
      image = open(auth.info.image)
      user.avatar.attach(io: image, filename: 'avatar.jpg', content_type: image.content_type)
      user.save
      user
    end

  end
end

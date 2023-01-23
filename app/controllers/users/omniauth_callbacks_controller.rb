class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # See https://github.com/omniauth/omniauth/wiki/FAQ#rails-session-is-clobbered-after-callback-on-developer-strategy
  skip_before_action :verify_authenticity_token, only: :openid_connect
  def openid_connect
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      success
    else
      failure
    end
  end

  def success
    sign_in_and_redirect @user
    set_flash_message(:notice, :success, kind: "OpenID Connect") if is_navigational_format?
    Group.default_hpi.members << @user
  end

  def failure
    set_flash_message(:alert, :failure, kind: OmniAuth::Utils.camelize(failed_strategy.name), reason: failure_message)
    redirect_to root_path
  end
end

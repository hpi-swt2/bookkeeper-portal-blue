class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def openid_connect
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, kind: "OpenID Connect") if is_navigational_format?
    else
      set_flash_message(:alert, :failure, kind: OmniAuth::Utils.camelize(failed_strategy.name), reason: failure_message)
      redirect_to root_path
    end
  end

  def failure
    set_flash_message(:alert, :failure, kind: OmniAuth::Utils.camelize(failed_strategy.name), reason: failure_message)
    redirect_to root_path
  end
end
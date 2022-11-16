class Users::RegistrationsController < Devise::RegistrationsController
  def profile
    @user = current_user
  end
end

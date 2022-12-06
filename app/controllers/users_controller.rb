class UsersController < Devise::RegistrationsController
  def profile
    @user = current_user
  end

  def dashboard
    @user = current_user
  end
end

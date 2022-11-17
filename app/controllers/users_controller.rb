class UsersController < Devise::RegistrationsController
  def profile
    @user = current_user
  end
end

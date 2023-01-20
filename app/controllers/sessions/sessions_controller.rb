module Sessions
  class SessionsController < Devise::SessionsController
    # GET /resource/sign_in
    def new
      @sign_in_method = params[:method] || 'choose'
      super
    end
  end
end

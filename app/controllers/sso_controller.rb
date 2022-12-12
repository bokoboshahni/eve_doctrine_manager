class SSOController < ApplicationController
  skip_before_action :store_user_location!

  def eve
    user = User.authenticate_from_sso!(auth.uid)
    if user
      sign_in_and_redirect(user, event: :authentication)
    else
      redirect_to root_path
    end
  end

  def failure
    flash[:error] = 'Authentication failed.'
    redirect_to root_path
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end

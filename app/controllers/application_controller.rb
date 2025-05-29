class ApplicationController < ActionController::Base
  skip_forgery_protection
  before_action :authenticate_user!,  {:alert => "You need to sign in or sign up before continuing."}

  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    # For account updates (editing profile)
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :private])

    # If you also want these on sign_up, you'd add:
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :private])
  end
end

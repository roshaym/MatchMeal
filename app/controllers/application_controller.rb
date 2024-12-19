class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?


  # # Redirect user to their profile page after successful sign up
  # def after_sign_up_path_for(resource)
  #   puts "Redirecting to: #{user_path(resource)}"
  #   user_path(resource)
  # end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path # Redirects to the sign-in page
  end

  def default_url_options
    { host: ENV["DOMAIN"] || "localhost:3000" }
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end
end

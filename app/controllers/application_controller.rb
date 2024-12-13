class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  # Redirect user to their profile page after successful sign up
  def after_sign_up_path_for(resource)
    puts "Redirecting to: #{user_path(resource)}"
    user_path(resource)
  end


  # optional, but I leave it here for now
  def after_sign_in_path_for(resource)
    user_path(resource)
  end
end

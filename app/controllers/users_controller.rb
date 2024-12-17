class UsersController < ApplicationController
  before_action :authenticate_user!  # Ensure user is logged in

  def show
    @user = User.find_by(id: params[:id])  # Find user by ID
  end

  def edit
    @user = current_user  # Set @user to the logged-in user
  end

  def update
    # Check if password is being updated
    password_changed = user_params[:password].present?

    if password_changed
      # If password is updated, update normally
      if current_user.update(user_params)
        sign_out(current_user)  # Sign out the user (optional, if password is updated)
        flash[:notice] = 'Profile updated successfully. Please log in again.'
        redirect_to new_user_session_path  # Redirect to login page
      else
        render :edit  # If update fails, render the edit page again
      end
      # If password is not updated, update without password
    elsif current_user.update_without_password(user_params)
      flash[:notice] = 'Profile updated successfully.'
      redirect_to user_path(current_user)  # Redirect to user's show page
    else
      render :edit  # If update fails, render the edit page again
    end
  end



  private

  def set_user
    @user = User.find(params[:id])  # Finds the user, raises ActiveRecord::RecordNotFound if not found
  end

  def user_params
    permitted_params = params.require(:user).permit(:first_name, :last_name, :email, :profile_picture, :password, :password_confirmation)
    permitted_params.delete(:password) if permitted_params[:password].blank?
    permitted_params.delete(:password_confirmation) if permitted_params[:password_confirmation].blank?
    # Only permit password fields if they're present
    # if params[:user][:password].present?
      # permitted_params[:password] = params[:user][:password]
      # permitted_params[:password_confirmation] = params[:user][:password_confirmation]
    # end

    permitted_params
  end

end

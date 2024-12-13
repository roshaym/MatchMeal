class UsersController < ApplicationController
  before_action :authenticate_user!  # Ensure user is logged in

  def show
    @user = User.find_by(id: params[:id])  # Find user by ID
  end

  def edit
    @user = current_user  # Set @user to the logged-in user
  end


  def update
    @user = current_user

    # Flag to check if password was updated
    password_changed = user_params[:password].present?

    if @user.update(user_params)
      if password_changed
        # If password is updated, sign out the user and send them to login
        sign_out(@user)
        flash[:notice] = "Password updated successfully. Please log in again."

        respond_to do |format|
          format.turbo_stream do
            # Turbo handles the redirect by replacing "error_message" with the flash message
            render turbo_stream: turbo_stream.replace("error_message", partial: "shared/flash_message")
          end
          format.html { redirect_to new_user_session_path, notice: "Password updated successfully. Please log in again." }
          format.json { render json: { notice: "Password updated successfully. Please log in again." } }
        end
      else
        # If no password update, simply redirect to profile page
        respond_to do |format|
          format.turbo_stream do
            # Turbo handles the redirect by replacing "error_message" with the flash message
            render turbo_stream: turbo_stream.replace("error_message", partial: "shared/flash_message")
          end
          format.html { redirect_to user_path(@user), notice: "Profile updated successfully!" }
          format.json { render json: { notice: "Profile updated successfully!" } }
        end
      end
    else
      # Handle errors in case update fails
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("error_message", partial: "shared/error_messages", locals: { errors: @user.errors.full_messages })
        end
        format.html { render :edit }
        format.json { render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end




  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :profile_picture, :password, :password_confirmation)
  end
end

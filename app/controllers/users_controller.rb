class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Correct redirection to the user's profile page
      redirect_to @user, notice: 'Profile created successfully!'
    else
      # If validation fails, re-render the new page
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'Profile updated successfully!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    unless @user
      redirect_to users_path, alert: "User not found"
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :profile_picture, :password, :password_confirmation)
  end
end

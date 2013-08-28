class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  def new
  	 @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      create_user_database
      sign_in @user
    	flash[:success] = "#{@user.name} registered!"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def index
    @users = User.all
  end

  private

    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation)
    end
end
class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update]
  before_filter :correct_user,   only: [:edit, :update]

  def create_user_database
    #File.open( @user.database_path, 'w+') do |f|
    #  f.write("database_details: \n adapter: mysql \n database: client_db_name \n username: root \n password:")
    #end
  end

  def destroy_user_database
    #File.delete @user.database_path
  end

  def new
  	 @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      create_user_database
      sign_in @user
    	flash[:success] = "#{@user.name} registered!"
      redirect_to action:'index', controller:'orders'
    else
      render 'new'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    destroy_user_database
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  private

    

    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation)
    end

    def signed_in_user
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
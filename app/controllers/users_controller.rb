class UsersController < ApplicationController
  def new
  end

  def create
    user = User.new(user_params)
    if user.save
      # user.username = params[:user][:username]
      # user.email = params[:user][:email]
      # user.password = params[:user][:password]
      # user.save

      session[:user_id] = user.id
      session[:username] = user.username
      session[:email] = user.email

      redirect_to root_path
    else
      @errors = user.errors.full_messages
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end

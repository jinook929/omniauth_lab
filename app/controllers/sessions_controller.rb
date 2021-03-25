class SessionsController < ApplicationController
  # This is required because of a quirk the "developer" authentication
  # strategy. We'll remove this when we move to a "real" provider.
  skip_before_action :verify_authenticity_token, only: :create

  def new

  end

  def create
    # After entering a name and email value in the /auth/developer
    # path and submitting the form, you will see a pretty-print of
    # the authentication data object that comes from the "developer"
    # strategy. In production, we'll swap this strategy for something
    # like 'github' or 'facebook' or some other authentication broker
    if auth # when OmniAuth login

      pp auth

      puts '#############################################################'
      puts auth[:info]
      puts '#############################################################'
      
      user = User.find_by(email: auth['info']['email'])
      if user
        session[:name] = auth['info']['name']
        session[:nickname] = auth['info']['nickname'] || auth['info']['email'].scan(/(.+)@/).flatten[0]
        session[:email] = auth['info']['email']
        session[:image] = auth['info']['image']
        session[:omniauth_data] = auth
        # byebug  
        session[:user_id] = user.id
        redirect_to root_path
      else
        # We're going to save the authentication information in the session
        # for demonstration purposes. We want to keep this data somewhere so that,
        # after redirect, we have access to the returned data
        session[:name] = auth['info']['name']
        session[:nickname] = auth['info']['nickname'] || auth['info']['email'].scan(/(.+)@/).flatten[0]
        session[:email] = auth['info']['email']
        session[:image] = auth['info']['image']
        session[:omniauth_data] = auth

        uname = auth['info']['nickname'] || auth['info']['email'].scan(/(.+)@/).flatten[0]
        user = User.create(username: uname, email: auth['info']['email'], password: SecureRandom.hex(10))
        session[:user_id] = user.id

        # user.username = auth['info']['nickname'] || auth['info']['email'].scan(/(.+)@/).flatten[0]
        # user.email = auth['info']['email']
        # user.password = SecureRandom.hex(10)
        # user.save

        # Ye olde redirect
        redirect_to root_path
      end

    else # when normal login

      @user = User.find_by(username: params[:user][:username])
      if @user.nil?
        @error = "Username not found."
        render 'new'

      elsif !@user.authenticate(params[:user][:password])
        @error = "Password is not correct."
        render 'new'

      else
        session[:user_id] = @user.id
        session[:username] = @user.username
        session[:email] = @user.email

        redirect_to root_path
      end
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end

  # def omniauth
  #   @user = User.from_omniauth(auth)
  #   @user.save
  #   session[:user_id] = @user.id
  #   redirect_to root_path
  # end

  private

  def auth
    request.env['omniauth.auth']
  end
end

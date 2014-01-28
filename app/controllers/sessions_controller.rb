class SessionsController < ApplicationController
  
  def new
    render 'new', :layout => "login"
  end
  
  def create_facebook
    user = User.from_omniauth(env["omniauth.auth"])
    sign_in user
    redirect_to root_url
  end
  
  def create
    user = User.find_by_email(params[:email].downcase)
    if user && user.authenticate(params[:password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new', :layout => "login"
    end
  end
  
  def destroy
    sign_out
    redirect_to root_url
  end
end

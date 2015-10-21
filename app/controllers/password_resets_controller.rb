class PasswordResetsController < ApplicationController
  before_filter :get_user,   only: [:edit, :update]
  before_filter :valid_user, only: [:edit, :update]
  before_filter :check_expiration, only: [:edit, :update]

  def new
    render 'new', :layout => "login"
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit', :layout => "login"
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit', :layout => "login"
    end
  end

  def create
    @user = User.find_by_email(params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new', :layout => "login"
    end
  end

  def edit
    render 'edit', :layout => "login"
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # Before filters

    def get_user
      @user = User.find_by_email(params[:email])
    end

    # Confirms a valid user.
    def valid_user
      unless (@user &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # Checks expiration of reset token.
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end

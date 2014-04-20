class UsersController < ApplicationController
  before_filter :signed_in_user, 
                only: [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    if(@user == current_user)
      @bookmarks = Bookmark.find_all_by_user_id(params[:id])
    end
  end
  
  def create
    if(params['agrees'])
      if(params['oauth_token'])
        #create using facebook
        @user = User.create_through_fb(params[:user])
        @user.save
      else
        #create by itself
        @user = User.new(params[:user])
      end

      if @user.save
        sign_in @user
        flash[:success] = "Welcome to Scuderia!"
        redirect_to @user
      else
        @user = User.new
        render 'new', :layout => "login"
      end
      return
    else
      flash[:error] = "You need to agree to the terms of service"
      @user = User.new
      render 'new', :layout => "login"
    end
  end
  
  def facebook_callback
    @user_fb = request.env['omniauth.auth']
    user = User.find_by_uid(@user_fb.uid)
    
    if(user && current_user.email == @user_fb.info.email)
      sign_in user
      redirect_to user
      return
    else
      sign_in current_user
      redirect_to current_user
      return
    end
    
    if(signed_in?)
      user_details = {
        provider:         @user_fb.provider,
        uid:              @user_fb.uid,
        oauth_token:      @user_fb.credentials.token,
        oauth_expires_at: Time.at(@user_fb.credentials.expires_at)
      }
      current_user.update_attributes!(user_details)
      redirect_to current_user
      return
    else
      @user = User.new
    end
    
    render 'facebook_callback', :layout => "login"
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def new
    @user = User.new
    render 'new', :layout => "login"
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  private
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end

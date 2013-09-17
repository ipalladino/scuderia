class TrimsController < ApplicationController
  before_filter :admin_user,     only: [:destroy, :create, :edit, :new]
  
  def index
    @trims = Trim.paginate(page: params[:page])
  end
  
  def show
    @trim = Trim.find(params[:id])
  end
  
  def create
    @trim = Trim.new(params[:trim])
    if @trim.save
      flash[:success] = "The body type was created"
      redirect_to @trim
    else
      flash[:error] = "Error creating body type"
      render 'new'
    end
  end
  
  def edit
    @trim = Trim.find(params[:id])
  end

  def update
    @trim = Trim.find(params[:id])
    if @trim.update_attributes(params[:trim])
      flash[:success] = "The body type was updated"
      redirect_to @trim
    else
      @trim = Trim.find(params[:id])
      render 'new'
    end
  end
  
  def destroy
    Trim.find(params[:id]).destroy
    flash[:success] = "Body type destroyed."
    redirect_to trims_url
  end

  def new
    @trim = Trim.new
  end
  
  private 
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
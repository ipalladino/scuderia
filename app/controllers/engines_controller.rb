class EnginesController < ApplicationController
  before_filter :admin_user,     only: [:destroy, :create, :edit, :new]
  
  def index
    @engines = Engine.paginate(page: params[:page])
  end
  
  def show
    @engine = Engine.find(params[:id])
  end
  
  def create
    @engine = Engine.new(params[:engine])
    if @engine.save
      flash[:success] = "The engine was created"
      redirect_to engines_url
    else
      render 'new'
    end
  end
  
  def edit
    @engine = Engine.find(params[:id])
  end

  def update
    @engine = Engine.find(params[:id])
    if @engine.update_attributes(params[:engine])
      flash[:success] = "The Engine was updated"
      redirect_to @engine
    else
      @engine = Engine.find(params[:id])
      render 'new'
    end
  end
  
  def destroy
    Engine.find(params[:id]).destroy
    flash[:success] = "Transmission destroyed."
    redirect_to engines_url
  end

  def new
    @engine = Engine.new
  end
  
  private 
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
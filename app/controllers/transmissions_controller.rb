class TransmissionsController < ApplicationController
  before_filter :admin_user,     only: [:destroy, :create, :edit, :new]
  
  def index
    @transmissions = Transmission.paginate(page: params[:page])
  end
  
  def show
    @transmission = Transmission.find(params[:id])
  end
  
  def create
    @transmission = Transmission.new(params[:transmission])
    begin
      @transmission.save
      redirect_to @transmission
    rescue
      flash[:error] = "Error #{$!}"
      render 'new'
    end
  end
  
  def edit
    @transmission = Transmission.find(params[:id])
  end

  def update
    @transmission = Transmission.find(params[:id])
    if @transmission.update_attributes(params[:transmission])
      flash[:success] = "The Transmission was updated"
      redirect_to @transmission
    else
      @transmission = Transmission.find(params[:id])
      render 'new'
    end
  end
  
  def destroy
    Transmission.find(params[:id]).destroy
    flash[:success] = "Transmission destroyed."
    redirect_to transmissions_url
  end

  def new
    @transmission = Transmission.new
  end
  
  private 
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
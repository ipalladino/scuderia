class TransmissionsController < ApplicationController
  before_filter :admin_user,     only: [:destroy, :create, :edit, :new]
  
  def index
    @trims = Trim.paginate(page: params[:page])
  end
  
  def show
    @trim = Trim.find(params[:id])
    @carmodels = Carmodel.find_by_trim(@trim).paginate(page: params[:page])
  end
  
  def create
    if(!params[:ferrari][:car_model_id] || params[:name].blank?)
      flash[:error] = "Fields cannot be blank!"
      redirect_to new_transmission_path
    else
      begin
        carmodel = CarModel.find(params[:ferrari][:car_model_id])
        @transmission = carmodel.transmissions.build(name: params[:name])
        if @transmission.save
          flash[:success] = "Car Transmission added!"
          redirect_to car_models_path
        else
          render 'new'
        end
      rescue
        flash[:error] = "Error #{$!}"
        redirect_to new_transmission_path
        success = false
      end
    end
  end
  
  def year_selection
    @year = Year.find(params[:year])
    @carmodels = @year.car_models
    puts @carmodels
    
    respond_to do |format|
        format.js {  }
    end
  end
  
  def edit
  end

  def update
  end
  
  def destroy
  end

  def new
    @years = Year.all
    @trim = Trim.new
  end
  
  private 
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
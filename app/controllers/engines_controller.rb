class EnginesController < ApplicationController
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
      redirect_to new_engine_path
    else
      begin
        carmodel = CarModel.find(params[:ferrari][:car_model_id])
        @engine = carmodel.engines.build(name: params[:name])
        if @engine.save
          flash[:success] = "Car engine added!"
          redirect_to car_models_path
        else
          render 'new'
        end
      rescue
        flash[:error] = "Error #{$!}"
        redirect_to new_engine_path
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
    @years = Year.order("car_year ASC").all
    @trim = Trim.new
  end
  
  private 
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
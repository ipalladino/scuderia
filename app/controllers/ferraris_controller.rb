class FerrarisController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy, :my, :new]
  before_filter :correct_user,   only: [:destroy]
  
  def index
    @ferraris = Ferrari.paginate(page: params[:page])
  end
  
  def show
    @ferrari = Ferrari.find(params[:id])
  end
  
  def create
    @ferrari = current_user.ferraris.build(params[:ferrari])
    if @ferrari.save
      flash[:success] = "The Ferrari post was created"
      redirect_to @ferrari
    else
      @years = Year.all
      render 'new'
    end
  end
  
  def my
    @ferraris = current_user.ferraris.paginate(page: params[:page])
  end
  
  def year_selection
    @year = Year.find(params[:year])
    @carmodels = @year.car_models
    respond_to do |format|
        format.js {  }
    end
  end
  
  def model_selection
    @model = CarModel.find(params[:model])
    @trims = @model.trims
    @engines = @model.engines
    @transmissions = @model.transmissions
    
    respond_to do |format|
        format.js {  }
    end
  end
  
  def edit
    @years = Year.order("car_year ASC").all
    @ferrari = Ferrari.find(params[:id])
    @car_models = CarModel.where({ year_id: @ferrari.year_id})
    @trims = Trim.where({ car_model_id: @ferrari.car_model_id})
    @engines = Engine.where({ car_model_id: @ferrari.car_model_id})
    @transmissions = Transmission.where({ car_model_id: @ferrari.car_model_id})
    5.times { @ferrari.assets.build }
  end

  def update
    @ferrari = Ferrari.find(params[:id])
    if @ferrari.update_attributes(params[:ferrari])
      flash[:success] = "The Ferrari post was updated"
      redirect_to @ferrari
    else
      @years = Year.all
      render 'new'
    end
  end
  
  def destroy
    @ferrari.destroy
    redirect_to root_url
  end

  def new
    @years = Year.order("car_year ASC").all
    @ferrari = Ferrari.new
    5.times { @ferrari.assets.build }
  end
  
  private 
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    
    def correct_user
      @ferrari = current_user.ferraris.find_by_id(params[:id])
      redirect_to root_url if @ferrari.nil?
    end
end

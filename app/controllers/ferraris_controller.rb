class FerrarisController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy, :my]
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
  end

  def update
  end
  
  def destroy
  end

  def new
    @years = Year.all
    @ferrari = Ferrari.new
  end
  
  private 
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    
    def correct_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_url if @micropost.nil?
    end
end

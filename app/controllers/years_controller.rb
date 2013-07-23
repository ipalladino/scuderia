class YearsController < ApplicationController
  before_filter :admin_user,     only: [:destroy, :create, :edit, :new]
  
  def index
    @years = Year.order("car_year ASC").paginate(page: params[:page])
  end
  
  def show
    @year = Year.find(params[:id])
    @carmodels = @year.car_models.paginate(page: params[:page])
  end
  
  def create
    @year = Year.new(params[:year])
    if @year.save
      flash[:success] = "The year was created"
      redirect_to @year
    else
      render 'new'
    end
  end
  
  def edit
  end

  def update
  end
  
  def destroy
    @year = Year.find(params[:id])
    if @year.destroy
      flash[:success] = "Year removed successfully"
    end
    redirect_to years_path
  end

  def new
    @year = Year.new
  end
  
  private 
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end

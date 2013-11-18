class FerrarisController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy, :my, :new]
  before_filter :correct_user,   only: [:destroy]
  
  def index
    @ferraris = Ferrari.paginate(page: params[:page])
    years = Year.all(select: "car_year,id")
    #MASSAGE FOR JS
    yearsx = []
    years.each do |y| 
      yearsx.push(y.serializable_hash)
    end
    mappings = {"id" => "value", "car_year" => "label"}
    yearsx.each do |y|
      y.keys.each { |k| y[ mappings[k] ] = y.delete(k) if mappings[k] }
    end
    
    @years = yearsx.to_json()
  end
  
  def show
    @ferrari = Ferrari.find(params[:id])
  end
  
  def crawl
    agent = Mechanize.new
    page = agent.get "http://www.ferraridatabase.com/The_Cars/Cars.htm"
    links = page.links
    links.shift

    links.each do |l|
      year_page = l.click
      year_string = l.text
      
      year = Year.find_by_car_year(year_string)
      if !year
        #create
        year = Year.new({car_year: year_string})
        year.save
      end
      
      ferraris_nodes = year_page.search("p//font//i")
      ferraris_nodes.each do |ferrari|
        ferrari_model = ferrari.children.text.strip.gsub("\u00A0", "")
        puts "Creating ferrari model: "+ferrari_model
        if(ferrari_model.split("the Cars").length == 1)
          car_model = year.car_models.find_by_car_model(ferrari_model)
          if(!car_model)
            car_model = year.car_models.build({car_model: ferrari_model})
            car_model.save
          end
        end
      end
      
      ferraris_nodes = year_page.search("td//font//font//i")
      ferraris_nodes.each do |ferrari|
        ferrari_model = ferrari.children.text.strip.gsub("\u00A0", "")
        puts "Creating ferrari model: "+ferrari_model
        if(ferrari_model.split("the Cars").length == 1)
          car_model = year.car_models.find_by_car_model(ferrari_model)
          if(!car_model)
            car_model = year.car_models.build({car_model: ferrari_model})
            car_model.save
          end
        end
      end
      
      ferraris_nodes = year_page.search("td//font//i")
      ferraris_nodes.each do |ferrari|
        ferrari_model = ferrari.children.text.strip.gsub("\u00A0", "")
        puts "Creating ferrari model: "+ferrari_model
        if(ferrari_model.split("the Cars").length == 1)
          car_model = year.car_models.find_by_car_model(ferrari_model)
          if(!car_model)
            car_model = year.car_models.build({car_model: ferrari_model})
            car_model.save
          end
        end
      end
      
    end
    
    redirect_to ferraris_path
  end
  
  def create
    @ferrari = current_user.ferraris.build(params[:ferrari])
    if @ferrari.save
      flash[:success] = "The Ferrari post was created"
      redirect_to @ferrari
    else
      @years = Year.all
      @trims = Trim.all
      @engines = Engine.all
      @transmissions = Transmission.all
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
  
  #def model_selection
  #  @model = CarModel.find(params[:model])
  #  @trims = @model.trims
  #  @engines = @model.engines
  #  @transmissions = @model.transmissions
    
  #  respond_to do |format|
  #      format.js {  }
  #  end
  #end
  
  def edit
    @years = Year.order("car_year ASC").all
    @ferrari = Ferrari.find(params[:id])
    @car_models = CarModel.where({ year_id: @ferrari.year_id})
    @trims = Trim.all
    @engines = Engine.all
    @transmissions = Transmission.all
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
    @ferrari = Ferrari.new
    @years = Year.order("car_year ASC").all
    @trims = Trim.all
    @engines = Engine.all
    @transmissions = Transmission.all
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

require 'wikipedia'
class CarModelsController < ApplicationController
  before_filter :admin_user,     only: [:destroy, :create, :edit, :new]
  
  def index
    @paginate = false
    if(params[:from] && params[:to].blank?)
      year = Year.find_by_car_year(params[:from])
      @car_models = CarModel.where(year_id: year.id)
    elsif(params[:from] && params[:to])
      @car_models = CarModel.joins(:year).find(:all, :conditions => ['car_year >= ? AND car_year <= ?', params[:from], params[:to]])
    else
      @paginate = true
      @car_models = CarModel.joins(:year).order("car_year ASC").paginate(page: params[:page])
    end
    
    years = Year.all(select: "car_year,id", order: "car_year ASC")
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
    #@car_models = CarModel.paginate(page: params[:page])
  end
  
  def search
    search_model = []
    if(params[:model])
      search_model = CarModel.find(:all, select: "year_id, car_models.id ,car_model", conditions: ["car_model like ?", "%#{params[:model]}%"])
    end
    if(params[:from] && params[:to])
      car_models = CarModel.joins(:year).find(:all, select: "year_id, car_models.id ,car_model", :conditions => ['car_year >= ? AND car_year <= ?', params[:from], params[:to]], order: ['car_year ASC'])
    else
      car_models = CarModel.joins(:year).find(:all, select: "year_id,car_models.id,car_model", order: ['car_year ASC'])
    end
    
    search_model.concat car_models
      
    render json: search_model.to_json(only: [ :id, :car_model ], methods: [:assets_urls, :car_model_str, :car_year_str])
  end
  
  def filter_by_year
    #debugger
    @car_models = CarModel.all
  end
  
  def filter_by_from_to
    @car_models = []
    if(params[:year_fr] == "Year Fr" || params[:year_fr].empty?)
      params[:year_fr] = nil
    end
    
    if(params[:year_to] == "Year To" || params[:year_to].empty?)
      params[:year_to] = nil
    end
    
    if(params[:year_fr]==nil && params[:year_to]==nil)
      render json: []
    end
    
    if(params[:year_fr] && params[:year_to])
      #if both year_fr and year_to are defined, we also need to check if they ar in right order
      yrfr = Integer(params[:year_fr])
      yrto = Integer(params[:year_to])
      if(yrfr <= yrto)
        #return correct stuff
        car_models = CarModel.joins(:year).find(:all, select: "car_model,car_models.id", :conditions => ['car_year >= ? AND car_year <= ?', params[:year_fr], params[:year_to]])
      end
    else
      #if only year_to is defined
      if(params[:year_to] && !params[:year_fr])
        car_models = CarModel.joins(:year).find(:all, select: "car_model,car_models.id",:conditions => ["car_year = ?", params[:year_to]])
      end
      #if only year_fr is defined
      if(params[:year_fr] && !params[:year_to])
        car_models = CarModel.joins(:year).find(:all, select: "car_model,car_models.id",:conditions => ["car_year = ?", params[:year_fr]])
      end
    end
    
    #MASSAGE FOR JS
    carmdx = []
    if(car_models)
      
      car_models.each do |c| 
        carmdx.push(c.serializable_hash)
      end
      mappings = {"id" => "value", "car_model" => "label"}
      carmdx.each do |y|
        y.keys.each { |k| y[ mappings[k] ] = y.delete(k) if mappings[k] }
      end

      render json: carmdx
    else
      render json: []
    end
    
  end
  
  def get_model
    if(params[:id])
      render json: CarModel.find(params[:id]).to_json(methods: [:assets_urls, :car_model_str, :car_year_str])
    else
      render json: {response: "not found"}
    end
  end
  
  def model_selection
    if(params[:id])
      carmodel = CarModel.find(params[:id])
      render json: CarModel.find(params[:id]).to_json(methods: [:assets_urls, :car_model_str, :car_year_str])
    else
      render json: {response: "not found"}
    end
  end
  
  
  def show
    @car_model = CarModel.find(params[:id])
    ferrari = "Ferrari " + @car_model.car_model
    ferrari_words = ferrari.split(" ")
    @modelFound = nil;
    while(ferrari_words.length > 0) do
      @wikipedia = Wikipedia.find(ferrari)
      if @wikipedia.content == nil
        ferrari_words.pop
        ferrari = ferrari_words.join(" ")
      else
        @modelFound = ferrari
        break
      end
    end
    
    if(@modelFound.strip! == "Ferrari")
      @modelFound = nil
    end
    
    dat = @wikipedia.page['revisions'][0]["*"]
    wiki = WikiCloth::Parser.new(:data => dat)
    @html = wiki.to_html({noedit: true})
    
    respond_to do |format|
        format.js {  }
        format.html {  }
    end
    #@trims = @carmodel.car_models.paginate(page: params[:page])
    #@engines = @carmodel.car_models.paginate(page: params[:page])
    #@transmissions = @carmodel.car_models.paginate(page: params[:page])
  end
  
  def create
    year = Year.find(params[:car_model][:year_id])
    params[:car_model].delete :year_id

    @carmodel = year.car_models.build(params[:car_model])
    if @carmodel.save
      flash[:success] = "Car model added!"
      redirect_to car_models_path
    else
      @feed_items = []
      render 'car_models/'
    end
  end
  
  def edit
    @years = Year.all
    @carmodel = CarModel.find(params[:id])
    5.times { @carmodel.generic_images.build }
  end

  def update
    @carmodel = CarModel.find(params[:id])
    if @carmodel.update_attributes(params[:car_model])
      flash[:success] = "The Ferrari post was updated"
      redirect_to @carmodel
    else
      @years = Year.all
      @carmodel = CarModel.find(params[:id])
      5.times { @carmodel.generic_images.build }
      render 'new'
    end
  end
  
  def destroy
    @carmodel = CarModel.find(params[:id])
    if @carmodel.destroy
        flash[:success] = "Car model removed successfully"
    end 
    redirect_to car_models_path
  end

  def new
    @carmodel = CarModel.new
    @years = Year.order("car_year ASC").all
    5.times { @carmodel.generic_images.build }
  end
  
  private 
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end

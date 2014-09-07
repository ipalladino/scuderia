class FerrarisController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy, :my, :new]
  before_filter :correct_user,   only: [:destroy, :preview, :confirm]

  def index
    @ferraris = Ferrari.paginate(page: params[:page])
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
  end

  def show
    @ferrari = Ferrari.find(params[:id])
    respond_to do |format|
      format.html # new.html.erb
      format.json  { render :json => @ferrari.to_json(methods: [:assets_urls, :car_model_str, :car_year_str]) }
    end
  end

  def search
    year_fr = params[:year_fr]
    year_to = params[:year_to]
    modelstr = params[:car_model]
    prce_fr = params[:price_fr]
    prce_to = params[:price_to]
    sort_by = params[:sort_by]
    user_id = params[:user_id]
    keywords = params[:keywords]


    if(modelstr && modelstr.empty?)
      modelstr = nil
    end
    if(prce_to && prce_to.empty?)
      prce_to = nil
    end
    if(prce_fr && prce_fr.empty?)
      prce_fr = nil
    end

    if(sort_by == nil)
      sort_by = "created_at:DESC".split(":")
    else
      sort_by = sort_by.split(":")
    end

    if(user_id)
      ferraris = Ferrari.find(:all, conditions: ["user_id = #{user_id} AND published = TRUE"], order: "#{sort_by[0]} #{sort_by[1]}")
      return render json: ferraris.to_json(methods: [:assets_urls, :car_model_str, :car_year_str])
    end

    if(modelstr == nil && !prce_to && !prce_fr && !year_fr && !year_to)
        ferraris = Ferrari.find(:all, conditions: ["published = TRUE"], order: "#{sort_by[0]} #{sort_by[1]}")
    end

    if(modelstr)
        query_string_for_models = "car_model like '%"+modelstr+"%'"
        puts "searching: " +query_string_for_models

        backup_search = Ferrari.joins(:car_model).find(:all, conditions: query_string_for_models, order: "#{sort_by[0]} #{sort_by[1]}")

        if(prce_to)
          if(!query_string_for_models.empty?)
            query_string_for_models += " AND "
          end
          query_string_for_models += "price <= #{prce_to}"
        end
        if(prce_fr)
          if(!query_string_for_models.empty?)
            query_string_for_models += " AND "
          end
          query_string_for_models += "price >= #{prce_fr}"
        end

        if(year_fr && !year_fr.empty?)
          if(!query_string_for_models.empty?)
            query_string_for_models += " AND "
          end
          query_string_for_models += "car_year >= '#{year_fr}'"
        end

        if(year_to && !year_to.empty?)
          if(!query_string_for_models.empty?)
            query_string_for_models += " AND "
          end
          query_string_for_models += "car_year <= '#{year_to}'"
        end

        query_string_for_models_with_keywords = query_string_for_models

        if(!keywords.empty?)
          if(!query_string_for_models_with_keywords.empty?)
            query_string_for_models_with_keywords += " AND ("
          end
          index = 0
          keywords_arr = keywords.split(",")
          if(keywords.length > 0)
            keywords_arr.each do |keyword|
              if(index != 0)
                query_string_for_models_with_keywords += " OR "
              end
              query_string_for_models_with_keywords += "transmissions.name LIKE '%#{keyword}%' OR color LIKE '%#{keyword}%' OR engines.name LIKE '%#{keyword}%'"
              index = index + 1
            end
          end


          if(index != 0)
            query_string_for_models_with_keywords += ")"
          end
        end

        ferraris = Ferrari.joins(:car_model, :year, :transmission, :engine).find(:all, conditions: query_string_for_models_with_keywords, order: "#{sort_by[0]} #{sort_by[1]}")
        #ferraris = Ferrari.joins(:car_model, :year).find(:all, conditions: query_string_for_models, order: "#{sort_by[0]} #{sort_by[1]}")

        if(ferraris.length == 0 && backup_search.length == 0)
          ferraris = Ferrari.find(:all, conditions: ["published = TRUE"], order: "#{sort_by[0]} #{sort_by[1]}")
        end
        ferraris.concat backup_search
    else
        query = ""
        if((year_to && !year_to.empty?) && (year_fr && !year_fr.empty?))
          query = "car_year >= '#{year_fr}' AND car_year <= '#{year_to}'"
        elsif((year_to && !year_to.empty?) && (!year_fr || year_fr.empty?))
          query = "car_year = '#{year_to}'"
        elsif((year_fr && !year_to.empty?) && (!year_fr || year_fr.empty?))
          query = "car_year = '#{year_fr}'"
        end

        if(prce_to && prce_fr)
          if(query.blank?)
            query = query + "price >= #{prce_fr} AND price <= #{prce_to}"
          else
            query = query + " AND price >= #{prce_fr} AND price <= #{prce_to}"
          end
        elsif(prce_to && !prce_fr)
          if(query.blank?)
            query = query + "price <= #{prce_to}"
          else
            query = query + " AND price <= #{prce_to}"
          end
        elsif(!prce_to && prce_fr)
          if(query.blank?)
            query = query + "price >= #{prce_fr}"
          else
            query = query + " AND price >= #{prce_fr}"
          end
        end

        if(!query.blank?)
          ferraris = Ferrari.joins(:year).find(:all, conditions: query+"AND published = TRUE", order: "#{sort_by[0]} #{sort_by[1]}")
        else
          ferraris = Ferrari.joins(:year).find(:all, conditions: "published = TRUE", order: "#{sort_by[0]} #{sort_by[1]}")
        end
    end

    render json: ferraris.to_json(methods: [:assets_urls, :car_model_str, :car_year_str])
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
      redirect_to "/ferraris/#{@ferrari.id}/preview"
    else
      @years = Year.order("car_year ASC").all
      @engines = Engine.all
      @transmissions = Transmission.all
      10.times { @ferrari.assets.build }
      respond_to do |format|
        format.html { render action: "new" }
        format.json { render json: @ferraris.errors, status: :unprocessable_entity }
      end
    end
  end

  def preview
    @ferrari = Ferrari.find(params[:id])
  end

  def confirm
    @ferrari = Ferrari.find(params[:id])
    @order = Order.new
  end

  def publish
    @ferrari = Ferrari.find(params[:id])
    @ferrari.published = true
    @ferrari.save
    redirect_to @ferrari
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
    @engines = Engine.all
    @transmissions = Transmission.all
    assets_to_build = 10-@ferrari.assets.length
    assets_to_build.times { @ferrari.assets.build }
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
    @engines = Engine.all
    @transmissions = Transmission.all
    10.times { @ferrari.assets.build }
  end

  def add_image
    #debugger
    if(params[:id] && params[:file])
      #process image and add it to the record
      ferrari = Ferrari.find(params[:id])
      message = [:added => true, :id => params[:id]];
      ferrari.assets.build(image: File.open(params[:file].tempfile))
      ferrari.save
      #params[:file]['datafile'].original_filename
      #ferrari.assets.build(File.open(params[:file].tempfile))
    else
      #message we cant process
      message = [:added => false]
    end
    render json: message.to_json
  end

  def remove_image
    if(params[:id])
      #process remove image
      begin
        asset = Asset.find(params[:id]);
        asset.destroy
        message = [:removed => true]
      rescue
        message = [:removed => false]
      end
      render json: message.to_json
    else
      #message cant process
      message = [:removed => false]
      render json: message.to_json
    end
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

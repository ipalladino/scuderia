class BlogsController < ApplicationController
  before_filter :admin_user, only: [:new, :create, :edit, :update, :destroy]

  # GET /blogs
  # GET /blogs.json
  def index
    @blogs = Blog.all
    
    #render json: ferraris.to_json(methods: [:assets_urls, :car_model_str, :car_year_str])
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @blogs }
    end
  end
  
  def manage
    @blogs = Blog.all
    
    #render json: ferraris.to_json(methods: [:assets_urls, :car_model_str, :car_year_str])
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @blogs }
    end
  end

  # GET /blogs/1
  # GET /blogs/1.json
  def show
    @blog = Blog.find(params[:id])
    @blogs = Blog.all(order: "created_at DESC")

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @blog }
    end
  end

  # GET /blogs/new
  # GET /blogs/new.json
  def new
    @blog = Blog.new
    5.times { @blog.assets.build }
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @blog }
    end
  end

  # GET /blogs/1/edit
  def edit
    @blog = Blog.find(params[:id])
  end

  # POST /blogs
  # POST /blogs.json
  def create
    @blog = Blog.new(params[:blog])

    respond_to do |format|
      if @blog.save
        format.html { redirect_to @blog, notice: 'Blog was successfully created.' }
        format.json { render json: @blog, status: :created, location: @blog }
      else
        5.times { @blog.assets.build }
        format.html { render action: "new" }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /blogs/1
  # PUT /blogs/1.json
  def update
    @blog = Blog.find(params[:id])

    respond_to do |format|
      if @blog.update_attributes(params[:blog])
        format.html { redirect_to @blog, notice: 'Blog was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.json
  def destroy
    @blog = Blog.find(params[:id])
    @blog.destroy

    respond_to do |format|
      format.html { redirect_to blogs_url }
      format.json { head :no_content }
    end
  end
  
  private
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end

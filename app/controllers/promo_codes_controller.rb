class PromoCodesController < ApplicationController
  before_filter :admin_user,     only: [:destroy, :create, :edit, :new, :index, :show, :update]

  def search
    if(params[:code])
      @promo_code = PromoCode.where(code: params[:code])
    end


    render json: @promo_code.to_json(methods: [:discount_type])
  end

  # GET /promo_codes
  # GET /promo_codes.json
  def index
    @promo_codes = PromoCode.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @promo_codes }
    end
  end

  # GET /promo_codes/1
  # GET /promo_codes/1.json
  def show
    @promo_code = PromoCode.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @promo_code }
    end
  end

  # GET /promo_codes/new
  # GET /promo_codes/new.json
  def new
    @promo_code = PromoCode.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @promo_code }
    end
  end

  # GET /promo_codes/1/edit
  def edit
    @promo_code = PromoCode.find(params[:id])
  end

  # POST /promo_codes
  # POST /promo_codes.json
  def create
    @promo_code = PromoCode.new(params[:promo_code])

    respond_to do |format|
      if @promo_code.save
        format.html { redirect_to @promo_code, notice: 'Promo code was successfully created.' }
        format.json { render json: @promo_code, status: :created, location: @promo_code }
      else
        format.html { render action: "new" }
        format.json { render json: @promo_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /promo_codes/1
  # PUT /promo_codes/1.json
  def update
    @promo_code = PromoCode.find(params[:id])

    respond_to do |format|
      if @promo_code.update_attributes(params[:promo_code])
        format.html { redirect_to @promo_code, notice: 'Promo code was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @promo_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /promo_codes/1
  # DELETE /promo_codes/1.json
  def destroy
    @promo_code = PromoCode.find(params[:id])
    @promo_code.destroy

    respond_to do |format|
      format.html { redirect_to promo_codes_url }
      format.json { head :no_content }
    end
  end
end

class OrdersController < ApplicationController
  before_filter :admin_user,     only: [:destroy, :edit, :index, :show, :update]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.json
  def create
    @ferrari = Ferrari.find(params[:ferrari_id])
    @order = @ferrari.build_order(params[:order])
    @order.ip_address = request.remote_ip
    @order.publish_setting = params[:publish_setting]
    @promo_code = PromoCode.where(code: params[:promo_code])

    if(@promo_code.length > 0)
      @order.promo_code_id = @promo_code[0].id
    end

    if @order.save
      if @order.price_in_cents != 0
        if @order.purchase
          #render json: [@order, @ferrari, @order.transactions, @order.promo_code]
          @ferrari.publish
          #find possible saved searches
          query = ["year_to::integer >= (?) OR year_to::integer ISNULL",
                    "year_fr::integer <= (?) OR year_fr::integer ISNULL",
                    "price_fr::float <= (?) OR price_fr::float = (-1.00)",
                    "price_to::float <= (?) OR price_to::float = (-1.00)",
                    "car_model = '#{@ferrari.car_model.car_model}' OR car_model = ''"]

          ss = SavedSearch.where(query[0],[@ferrari.year.car_year]).where(query[1], [@ferrari.year.car_year]).where(query[2],[@ferrari.price.to_f]).where(query[3],[@ferrari.price.to_f]).where(query[4],[@ferrari.car_model.car_model])
          #notify the people that need to be notified
          url = request.protocol+request.host_with_port
          ss.each do |item|
            UserNotifier.send_saved_search_notification(item.user, @ferrari, item, url).deliver
          end

          #render json: [ss,@ferrari]
          redirect_to @ferrari
        else
          render text: "{message : 'failure'}"
        end
      else
        @ferrari.publish
        #find possible saved searches
        query = ["year_to::integer >= (?) OR year_to::integer ISNULL",
                  "year_fr::integer <= (?) OR year_fr::integer ISNULL",
                  "price_fr::float <= (?) OR price_fr::float = (-1.00)",
                  "price_to::float <= (?) OR price_to::float = (-1.00)",
                  "car_model = '#{@ferrari.car_model.car_model}' OR car_model = ''"]

        ss = SavedSearch.where(query[0],[@ferrari.year.car_year]).where(query[1], [@ferrari.year.car_year]).where(query[2],[@ferrari.price.to_f]).where(query[3],[@ferrari.price.to_f]).where(query[4],[@ferrari.car_model.car_model])
        #notify the people that need to be notified
        url = request.protocol+request.host_with_port
        ss.each do |item|
          UserNotifier.send_saved_search_notification(item.user, @ferrari, item, url).deliver
        end

        #render json: [ss,@ferrari]
        redirect_to @ferrari
      end
    else
      render :template => "ferraris/confirm"
    end

    #respond_to do |format|
    #  if @order.save
    #    format.html { redirect_to @order, notice: 'Order was successfully created.' }
    #    format.json { render json: @order, status: :created, location: @order }
    #  else
    #    format.html { render action: "new" }
    #    format.json { render json: @order.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PUT /orders/1
  # PUT /orders/1.json
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end
end

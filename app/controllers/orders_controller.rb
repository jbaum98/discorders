class OrdersController < ApplicationController
  @@atts = ['name', 'bunk']
  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all.reverse[0...10]
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

  # GET /orders/new
  # GET /orders/new.json
  def new
    @order = Order.new

    respond_to do |format|
      format.html # new.html.erb
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
    params['order']['name']=params['order']['name'].titleize
    params['order']['bunk']=params['order']['bunk'].capitalize
    @order = Order.new(params[:order])
    if @order.save
      flash[:ordered] = "Order placed for #{@order.name} in bunk #{@order.bunk} for #{@order.white} white, #{@order.orange} orange, and #{@order.blue} blue frisbees."
      if @order.paid
        flash[:success] = "#{@order.name} paid $#{@order.price}."
      else
        flash[:notpaid] = "Remeber to bring $#{@order.price} when you pick up your discs."
      end
      redirect_to root_path
    else
      render 'new'
    end
  end

  # PUT /orders/1
  # PUT /orders/1.json
  def update
    params['order']['name']=params['order']['name'].titleize
    params['order']['bunk']=params['order']['bunk'].capitalize
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

  def search
    @order = Order.all
  end

  def results
    params['name']=params['name'].titleize
    params['bunk']=params['bunk'].capitalize
    @orders = []
    params.each_key do |p|
      if @@atts.include?(p)
        Order.find_each(conditions: ["orders.? = ?", p, params[p]]) do |camper|
          @orders.append(camper)
        end
      end
    end
  end

  def all
    @orders = Order.all
  end
end

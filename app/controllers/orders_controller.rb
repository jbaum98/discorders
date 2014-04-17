class OrdersController < ApplicationController
  # GET /orders
  # GET /orders.json
  def index
    if not params[:id_array].nil?
      id_array = params[:id_array].split(",").map { |i| i.to_i}
      @orders = id_array.map { |id| Order.find(id)  }
    else
      @orders = all_orders
    end
    @orders.sort_by! {|x| x.created_at }.reverse!
    #@orders = @orders.paginate(page: params[:page], per_page: 10)
    #gon.orders = @orders

    redirect_to @orders[0] if @orders.size == 1
  end

  def recent
    @orders = all_orders
    @orders = @orders.paginate(page: params[:page], per_page: 10).order('created_at DESC')
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
    @order = signed_in? ? current_user.orders.new(params[:order]) : Order.new(params[:order])
    if @order.save
      flash[:info] = "Order placed for #{@order.name} in bunk #{@order.bunk} for #{@order.white} white, #{@order.orange} orange, and #{@order.blue} blue frisbees."
      if @order.paid
        flash[:success] = "#{@order.name} paid $#{@order.price}."
      else
        flash[:danger] = "Remeber to bring $#{@order.price} when you pick up your discs."
      end
      redirect_to root_path
    else
      render 'new'
    end
  end

  # PUT /orders/1
  # PUT /orders/1.json
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        message = case @order.received
          when true then {received: "#{@order.name} in bunk #{@order.bunk} has received his/her #{@order.white} white, #{@order.orange} orange, and #{@order.blue} blue frisbees."}
          when false then {notreceived: "#{@order.name} in bunk #{@order.bunk} has NOT received his/her #{@order.white} white, #{@order.orange} orange, and #{@order.blue} blue frisbees."}
          end
        format.html {
          if request.referer =~ /edit/
            redirect_to @order, notice: 'Order was successfully updated.'
          elsif request.referer =~ /index/
            redirect_to root_path, notice: 'Order was successfully updated.'
          else
            redirect_to request.referer, notice: 'Order was successfully updated.'
          end
        }
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

  def total
    @order_total = all_orders.size
    
    #white_total = blue_total = orange_total = []
    [:white, :orange, :blue].each do |color|
      instance_variable_set("@#{color}_count", [])
      all_orders.each {|order| instance_variable_get("@#{color}_count").append(order[color]) if order[color].is_a? Fixnum}
      instance_variable_set("@#{color}_total", instance_variable_get("@#{color}_count").sum)
    end
    @disc_total=@white_total+@blue_total+@orange_total
    @received_total=@price_total=0
    all_orders.each {|order| @received_total+=1 if order.received}
    all_orders.each {|order| @price_total+=order.price}
  end

  def data
    orders = all_orders
    data = orders.collect do |order|
      {name: order.name,
        bunk: order.bunk,
        id: order.id,
        white: order.white,
        orange: order.orange,
        blue: order.blue,
        paid: order.paid,
        price: order.price,
        received: order.received
      }
      end
    data.uniq!
    respond_to {|format| 
      format.html { redirect_to '/404.html'}
      format.json {render json: data}}
  end

end
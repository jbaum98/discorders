class OrdersController < ApplicationController
  @@atts = ['name', 'bunk']
  # GET /orders
  # GET /orders.json
  def index
    unless params['name'].nil? and params['bunk'].nil?
      params['name']&&=params['name'].titleize
      params['bunk']&&=params['bunk'].capitalize
      @orders = []
      params.each_key do |term|
        if @@atts.include? term and not params[term].empty?
          all_orders.each do |order|
            if order[term].include? params[term] or params[term].include? order[term]
              @orders.append(order) unless @orders.include? order or (params[:needy]=='1' and order.received)
            end
          end
        end
      end
      if params['name'].empty? and params['bunk'].empty?
        all_orders.each do |order|
          @orders.append(order) unless @orders.include? order or (params[:needy]=='1' and order.received)
        end
      end
    end
    @orders=all_orders if params['name'].nil? and params['bunk'].nil?

    params[:sort] ||= 'created_at'

    @orders.sort_by!{ |order| order[params[:sort]]} unless ['paid', 'received'].include? params[:sort]
    @orders.sort_by!{ |order| order[params[:sort]] ? 0 : 1} if ['paid', 'received'].include? params[:sort]
    @orders.reverse! if (params[:reverse] == "true")
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
      flash[:ordered] = "Order placed for #{@order.name} in bunk #{@order.bunk} for #{@order.white} white, #{@order.orange} orange, and #{@order.blue} blue frisbees."
      if @order.paid
        flash[:paid] = "#{@order.name} paid $#{@order.price}."
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
    params[:old_params] ||={}
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        message = case @order.received
          when true then {received: "#{@order.name} in bunk #{@order.bunk} has received his/her #{@order.white} white, #{@order.orange} orange, and #{@order.blue} blue frisbees."}
          when false then {notreceived: "#{@order.name} in bunk #{@order.bunk} has NOT received his/her #{@order.white} white, #{@order.orange} orange, and #{@order.blue} blue frisbees."}
          end
        format.html { redirect_to({url: request.referer}.merge(params[:old_params]), flash: message )} unless URI(request.referer).path.include? 'edit'
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

end
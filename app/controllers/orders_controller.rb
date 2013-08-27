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
          Order.all.each do |order|
            if order[term].include? params[term] or params[term].include? order[term]
              @orders.append(order) unless @orders.include? order or (params[:needy]=='1' and order.received)
            end
          end
        end
      end
      if params['name'].empty? and params['bunk'].empty?
        Order.all.each do |order|
          @orders.append(order) unless @orders.include? order or (params[:needy]=='1' and order.received)
        end
      end
    end
    @orders=Order.all if params['name'].nil? and params['bunk'].nil?

    params[:sort] ||= 'created_at'
    params[:reverse] ||= 'true'

    @orders.sort_by!{ |order| order[params[:sort]]}
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
    params['order']['name']=params['order']['name'].titleize unless params['order']['name'].nil?
    params['order']['bunk']=params['order']['bunk'].capitalize unless params['order']['bunk'].nil?
    @order = Order.new(params[:order])
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
    params['order']['name']=params['order']['name'].titleize unless params['order']['name'].nil?
    params['order']['bunk']=params['order']['bunk'].capitalize unless params['order']['bunk'].nil?
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

end
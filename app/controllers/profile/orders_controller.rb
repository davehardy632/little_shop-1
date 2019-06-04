class Profile::OrdersController < ApplicationController
  before_action :require_reguser

  def index

    @user = current_user
    @orders = current_user.orders
  end

  def show
    @order = Order.find(params[:id])
  end

  def destroy
    @order = Order.find(params[:id])
    if @order.user == current_user
      @order.order_items.where(fulfilled: true).each do |oi|
        item = Item.find(oi.item_id)
        item.inventory += oi.quantity
        item.save
        oi.fulfilled = false
        oi.save
      end

      @order.status = :cancelled
      @order.save

      redirect_to profile_orders_path
    else
      render file: 'public/404', status: 404
    end
  end

  def create
    unless cart.contents["coupon_id"] == 0
      coupon = Coupon.find(cart.contents["coupon_id"])
      discounted_price = cart.discounted_total
    end
    address = Address.find(params[:format])
    order = Order.create(user: current_user, status: :pending)
    order.address = address
    order.coupon = coupon if coupon
    order.discounted_price = discounted_price if discounted_price
    order.save
      cart.items.each do |item, quantity|
        order.order_items.create(item: item, quantity: quantity, price: item.price)
      end
    session.delete(:cart)
    cart.contents.clear
    cart.items.clear
    flash[:success] = "Your order has been created!"
    redirect_to profile_orders_path
  end
end

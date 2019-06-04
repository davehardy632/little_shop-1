class CartController < ApplicationController
  before_action :visitor_or_user

  def show
  end

  def increment
    item = Item.find(params[:id])
    if item.inventory <= cart.count_of(item.id)
      flash[:danger] = "The Merchant does not have enough inventory."
    else
      cart.add_item(item.id)
      session[:cart] = cart.contents
      flash[:success] = "#{item.name} has been added to your cart!"
    end
    redirect_to cart_path
  end

  def decrement
    item = Item.find(params[:id])
    cart.remove_item(item.id)
    session[:cart] = cart.contents
    flash[:success] = "#{item.name} has been removed from your cart."
    redirect_to cart_path
  end

  def destroy
    session.delete(:cart)
    redirect_to cart_path
  end

  def remove_item
    item = Item.find(params[:id])
    session[:cart].delete(item.id.to_s)
    flash[:success] = "#{item.name} has been removed from your cart."
    redirect_to cart_path
  end

  def add_coupon
    coupon = Coupon.find_by(name: params[:name])
    if current_user.orders == []
      cart.add_coupon(coupon.id)
      flash[:message] = "#{coupon.name} has been added to your order"
      redirect_to cart_path
    elsif current_user.orders != [] && current_user.include_coupon?(coupon.id)
      flash[:message] = "Coupons cannot be used twice, you have already used this coupon"
      redirect_to cart_path
    elsif current_user.orders != [] && current_user.include_coupon?(coupon.id) == false
      cart.add_coupon(coupon.id)
      flash[:message] = "#{coupon.name} has been added to your order"
      redirect_to cart_path
    end
  end
end

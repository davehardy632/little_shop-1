class Dashboard::CouponsController < Dashboard::BaseController

  def index
    @merchant = current_user
    @coupons = current_user.coupons
  end

  def new
    @merchant = current_user
    @coupon = Coupon.new
  end

  def create
    @merchant = current_user
    if @merchant.coupons.count > 4
      flash[:message] = "#{@merchant.name} cannot have more than five coupons"
      redirect_to dashboard_coupons_path
    else
      @coupon = Coupon.new(coupon_params)
      @merchant.coupons << @coupon
      if @coupon.save
        flash[:message] = "New Coupon Added!"
        redirect_to dashboard_coupons_path
      else
        flash[:danger] = @coupon.errors.full_messages
        render :new
      end
    end
  end

  def edit
    @coupon = Coupon.find(params[:id])
  end

  def update
    @coupon = Coupon.find(params[:id])
    if @coupon.update(coupon_params)
      flash[:message] = "Coupon has been updated"
      redirect_to dashboard_coupons_path
    else
      flash[:danger] = @coupon.errors.full_messages
      render :edit
    end
  end

  def destroy
    @coupon = Coupon.find(params[:id])
    if @coupon.orders.any?
      flash[:message] = "Cannot delete a coupon that has been used"
      redirect_to dashboard_coupons_path
    else
      @coupon.destroy
      flash[:message] = "Coupon Deleted"
      redirect_to dashboard_coupons_path
    end
  end

  def disable
    @coupon = Coupon.find(params[:id])
    @coupon.update_column(:enabled, false)
    flash[:message] = "Coupon #{@coupon.name} has been disabled"
    redirect_to dashboard_coupons_path
  end

  def enable
    @coupon = Coupon.find(params[:id])
    @coupon.update_column(:enabled, true)
    flash[:message] = "Coupon #{@coupon.name} has been enabled"
    redirect_to dashboard_coupons_path
  end

  private

  def coupon_params
    params.require(:coupon).permit(:name, :discount)
  end
end

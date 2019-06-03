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
    @coupon = Coupon.new(coupon_params)
    @merchant.coupons << @coupon
    if @coupon.save
      flash[:message] = "New Coupon Added!"
      redirect_to dashboard_coupons_path
    else
      render :new
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
      render :edit
    end
  end

  private

  def coupon_params
    params.require(:coupon).permit(:name, :discount)
  end
end

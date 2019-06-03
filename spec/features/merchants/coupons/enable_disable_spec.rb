require 'rails_helper'


describe "Merchant Can enable and disable Coupons" do
  before :each do
    @merchant = create(:merchant)
    login_as(@merchant)

    @coupon_1 = @merchant.coupons.create(name: "Coupon 1", discount: 2.00, enabled: true)
    @coupon_2 = @merchant.coupons.create(name: "Coupon 2", discount: 3.00, enabled: true)
    @coupon_3 = @merchant.coupons.create(name: "Coupon 3", discount: 4.00, enabled: false)

    visit dashboard_coupons_path
  end

  it "When I visit my coupons page, there is a button to disable each coupon" do

    within("#coupon-#{@coupon_1.id}") do
      click_button "Disable Coupon"
    end

    expect(current_path).to eq(dashboard_coupons_path)

    @coupon_1.reload
    expect(@coupon_1.enabled).to eq(false)

    within("#coupon-#{@coupon_1.id}") do
      expect(page).to have_content("Coupon is Disabled")
      expect(page).to have_button("Enable Coupon")
    end
  end

  it "When a coupon is disabled there is a button to enable it for each coupon on the index page" do

    within("#coupon-#{@coupon_3.id}") do
      click_button "Enable Coupon"
    end

    expect(current_path).to eq(dashboard_coupons_path)

    @coupon_3.reload
    expect(@coupon_3.enabled).to eq(true)
save_and_open_page
    within("#coupon-#{@coupon_3.id}") do
      expect(page).to have_content("Coupon is Enabled")
      expect(page).to have_button("Disable Coupon")
    end
  end
end

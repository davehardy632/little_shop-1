require 'rails_helper'


describe "Merchant Coupons" do
  before :each do
    @merchant = create(:merchant)
    login_as(@merchant)

    @coupon_1 = @merchant.coupons.create(name: "Coupon 1", discount: 2.00, enabled: true)
    @coupon_2 = @merchant.coupons.create(name: "Coupon 2", discount: 3.00, enabled: true)
    @coupon_3 = @merchant.coupons.create(name: "Coupon 3", discount: 4.00, enabled: true)
  end
  describe "From a merchant dashboard, there is a link to a coupon index page" do
    it "as a merchant, When I visit my dashboard, I click on 'My Coupons, and am taken to dashboard coupons'" do

      visit dashboard_path

      expect(page).to have_link("My Coupons")
      click_link "My Coupons"
      
      expect(current_path).to eq(dashboard_coupons_path)

      within("#coupon-#{@coupon_1.id}") do
        expect(page).to have_content(@coupon_1.name)
        expect(page).to have_content(@coupon_1.discount)
      end
      within("#coupon-#{@coupon_2.id}") do
        expect(page).to have_content(@coupon_2.name)
        expect(page).to have_content(@coupon_2.discount)
      end
      within("#coupon-#{@coupon_3.id}") do
        expect(page).to have_content(@coupon_3.name)
        expect(page).to have_content(@coupon_3.discount)
      end
    end
  end
end

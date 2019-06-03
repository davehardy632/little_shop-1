require 'rails_helper'


describe "Merchant Can Delete Coupons" do
  before :each do
    @merchant = create(:merchant)
    login_as(@merchant)

    @coupon_1 = @merchant.coupons.create(name: "Coupon 1", discount: 2.00, enabled: true)
    @coupon_2 = @merchant.coupons.create(name: "Coupon 2", discount: 3.00, enabled: true)
    @coupon_3 = @merchant.coupons.create(name: "Coupon 3", discount: 4.00, enabled: true)

    visit dashboard_coupons_path
  end
  describe "When I click the delete button on a coupon, a flash message is shown and I see that the coupon is no longer on the page" do
    it "As a merchant deleting a coupon" do

      within("#coupon-#{@coupon_1.id}") do
        click_button "Delete Coupon"
      end

      expect(current_path).to eq(dashboard_coupons_path)

      expect(page).to_not have_content(@coupon_1.name)
      expect(page).to_not have_content(@coupon_1.discount)
    end

    # it "Merchant cannot delete a coupon that has been used in an order" do
    #
    #
    # 
    # end
  end
end

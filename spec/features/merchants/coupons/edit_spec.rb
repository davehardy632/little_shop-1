require 'rails_helper'


describe "Merchant Can Edit Coupons" do
  before :each do
    @merchant = create(:merchant)
    login_as(@merchant)

    @coupon_1 = @merchant.coupons.create(name: "Coupon 1", discount: 2.00, enabled: true)
    @coupon_2 = @merchant.coupons.create(name: "Coupon 2", discount: 3.00, enabled: true)
    @coupon_3 = @merchant.coupons.create(name: "Coupon 3", discount: 4.00, enabled: true)

    visit dashboard_coupons_path
  end
  describe "For each coupon on the index page, there is a link to edit the coupon info" do
    it "When filled out the coupon info is changed" do

      new_name = "New Coupon Name"
      new_discount = 3.00

      within("#coupon-#{@coupon_1.id}") do
        click_link "Edit Coupon"
      end

      expect(current_path).to eq(edit_dashboard_coupon_path(@coupon_1))

      fill_in "Name", with: new_name
      fill_in "Discount", with: new_discount
      click_on "Update Coupon"

      expect(current_path).to eq(dashboard_coupons_path)
      expect(page).to have_content("Coupon has been updated")

      @coupon_1.reload

      within("#coupon-#{@coupon_1.id}") do
        expect(page).to have_content(new_name)
        expect(page).to have_content("Discount #{new_discount}")
      end
    end

    it "When updating/ changing a coupon, all fields must be present" do
      coupon = @merchant.coupons.create(name: "medium coupon", discount: 4.00, enabled: true)

      within("#coupon-#{@coupon_1.id}") do
        click_link "Edit Coupon"
      end

      fill_in "Name", with: ""
      fill_in "Discount", with: 5.00
      click_on "Update Coupon"


      expect(page).to have_content("Name can't be blank")

      visit dashboard_coupons_path

      within("#coupon-#{@coupon_1.id}") do
        click_link "Edit Coupon"
      end

      fill_in "Name", with: "name name"
      fill_in "Discount", with: ""
      click_on "Update Coupon"

      expect(page).to have_content("Discount can't be blank")
    end
  end
end

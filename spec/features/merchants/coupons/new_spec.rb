require 'rails_helper'

describe "Merchant can add coupons to coupon index page" do
  before :each do
    @merchant = create(:merchant)
    login_as(@merchant)

    visit dashboard_coupons_path

    click_link "Add a Coupon"
  end
  describe "As a merchant when i visit dashboard_coupons_path, there is a link to add a coupon" do
    it "When I click the link, I am taken to a new coupon form, fill it out and redirect to index w/ flash and new coupon" do

      expect(current_path).to eq(new_dashboard_coupon_path)

      fill_in "Name", with: "coupon 123"
      fill_in 'Discount', with: 2.00
      click_on "Create Coupon"

      expect(current_path).to eq(dashboard_coupons_path)
      expect(page).to have_content("New Coupon Added!")

      coupon = Coupon.last

      within("#coupon-#{coupon.id}") do
        expect(page).to have_content("coupon 123")
        expect(page).to have_content("Discount #{coupon.discount}")
      end
    end
  end
end

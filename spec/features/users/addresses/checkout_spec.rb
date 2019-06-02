require 'rails_helper'


describe "User cannot check out if all addresses are deleted" do
  before :each do
    @user = create(:user)
    login_as(@user)

    @item_1 = create(:item)
    @item_2 = create(:item)
    @item_3 = create(:item)

    @address_1 = @user.addresses.create(address: "1211 west 16th st", city: "Denver", state: "CO", zip: "80104",  nickname: "Work")

  visit profile_addresses_path

  within("#address-#{@address_1.id}") do
    click_link "Delete Address"
  end

    visit items_path

  end

  describe "If a user deletes all addresses they cannot check out" do
    it "deletes all items and tries to check out" do

    within("#item-#{@item_1.id}") do
      click_on "Add to Cart"
      click_on "Add to Cart"
      click_on "Add to Cart"
    end

    expect(current_path).to eq(cart_path)
    expect(page).to_not have_button("Check Out")
    expect(page).to have_content("You must Add a new Address to checkout")
    end
  end
end

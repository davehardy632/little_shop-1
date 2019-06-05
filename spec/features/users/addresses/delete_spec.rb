require 'rails_helper'

describe "User can delete an address from their address page in their profile" do
  before :each do
    @merchant = create(:merchant)
    @user = create(:user)
    login_as(@user)
      @address_1 = @user.addresses.create(address: "1211 west 16th st", city: "Denver", state: "CO", zip: "80104",  nickname: "Work")
      @address_2 = @user.addresses.create(address: "2033 north larimer st", city: "Chicago", state: "IL", zip: "80204", nickname: "Home")
      @address_3 = @user.addresses.create(address: "2244 blake st", city: "Boston", state: "MA", zip: "80304", nickname: "Other")

    visit profile_addresses_path
    within("#address-#{@address_1.id}") do
      click_link "Delete Address"
    end
  end

  describe "Happy Path" do
    it "When clicking delete, the address no longer appears and a flash message is displayed" do

      expect(page).to have_content("Address has been deleted")

      expect(page).to_not have_content(@address_1.address)
      expect(page).to_not have_content(@address_1.city)
      expect(page).to_not have_content(@address_1.state)
      expect(page).to_not have_content(@address_1.zip)
      expect(page).to_not have_content(@address_1.nickname)
    end

    it "address can be deleted if it is used in a pending order but the order is cancelled" do
      address_4 = @user.addresses.create(address: "1222 west 55th ave", city: "denver", state: "CO", zip: "12222")
        order = Order.create!(user: @user, address: address_4 )
        item = Item.create!(name: "item", price: 2.00, description: "item", image: "www.google.com", inventory: 44, user: @merchant)
          oi1 = OrderItem.create!(order: order, item: item, quantity: 10)

      visit profile_addresses_path

      within("#address-#{address_4.id}") do
        click_link "Delete Address"
      end

      expect(page).to have_content("Address is active on a pending order")
      expect(current_path).to eq(profile_addresses_path)
      expect(page).to have_content(address_4.address)
      expect(page).to have_content(address_4.city)
      expect(page).to have_content(address_4.state)
      expect(page).to have_content(address_4.zip)
    end
  end
end

require 'rails_helper'

describe "User can add a new address to their profile" do
  before :each do
    @user = create(:user)
    login_as(@user)

      @address_1 = @user.addresses.create(address: "1211 west 16th st", city: "Denver", state: "CO", zip: "80104",  nickname: "Home")
      @address_2 = @user.addresses.create(address: "2033 north larimer st", city: "Chicago", state: "IL", zip: "80204", nickname: "Work")
      @address_3 = @user.addresses.create(address: "2244 blake st", city: "Boston", state: "MA", zip: "80304", nickname: "Other")
  end
  describe "When I visit my addresses" do
    it "I click add an address, fill out form, and new address is displayed on my addresses index" do

      visit profile_addresses_path

      click_link "Add a new Address"

      expect(current_path).to eq(new_profile_address_path)

      fill_in "Address", with: "1211 hedge lane"
      fill_in "City", with: "St Louis"
      fill_in "State", with: "Missouri"
      fill_in "Zip", with: "52991"
      fill_in "Nickname", with: "Other"
      click_on "Create Address"

      expect(current_path).to eq(profile_addresses_path)

      address = Address.last

      within("#address-#{address.id}") do
        expect(page).to have_content("1211 hedge lane")
        expect(page).to have_content("St Louis")
        expect(page).to have_content("Missouri")
        expect(page).to have_content("52991")
        expect(page).to have_content("Other")
      end
    end

    it "When the user tries to add a new address without required fields, they are directed back and see a descriptive flash message" do

      visit profile_addresses_path

      click_link "Add a new Address"

      expect(current_path).to eq(new_profile_address_path)

      fill_in "Address", with: ""
      fill_in "City", with: ""
      fill_in "State", with: ""
      fill_in "Zip", with: ""
      fill_in "Nickname", with: ""
      click_on "Create Address"

      expect(current_path).to eq(profile_addresses_path)

      expect(page).to have_content("Address can't be blank")
      expect(page).to have_content("City can't be blank")
      expect(page).to have_content("State can't be blank")
      expect(page).to have_content("Zip can't be blank")
      expect(page).to have_content("Nickname home")
    end
  end
end

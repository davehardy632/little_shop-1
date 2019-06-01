require 'rails_helper'

describe "User can add a new address to their profile" do
  before :each do
    @user = create(:user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      @address_1 = @user.addresses.create(address_line: "1211 west 16th st", city: "Denver", state: "CO", zip: "80104",  nickname: "Home")
      @address_2 = @user.addresses.create(address_line: "2033 north larimer st", city: "Chicago", state: "IL", zip: "80204", nickname: "Work")
      @address_3 = @user.addresses.create(address_line: "2244 blake st", city: "Boston", state: "MA", zip: "80304", nickname: "Other")
  end
  describe "When I visit my addresses" do
    it "I click add an address, fill out form, and new address is displayed on my addresses index" do

      visit profile_addresses_path

      click_link "Add a new Address"

      expect(current_path).to eq(new_profile_address_path)

      fill_in "Address line", with: "1211 hedge lane"
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
  end
end

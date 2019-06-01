require 'rails_helper'

describe "User address index page" do
  before :each do
    @user = create(:user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      @address_1 = @user.addresses.create(address_line: "1211 west 16th st", city: "Denver", state: "CO", zip: "80104",  nickname: "Home")
      @address_2 = @user.addresses.create(address_line: "2033 north larimer st", city: "Chicago", state: "IL", zip: "80204", nickname: "Work")
      @address_3 = @user.addresses.create(address_line: "2244 blake st", city: "Boston", state: "MA", zip: "80304", nickname: "Other")
  end
  describe "When a user visits addresses index page" do
    it "They see a list of all their addresses and a nickname for each one" do

      visit edit_profile_path

      click_link "My Addresses"

      expect(current_path).to eq(profile_addresses_path)

      within("#address-#{@address_1.id}") do
        expect(page).to have_content(@address_1.address_line)
        expect(page).to have_content(@address_1.city)
        expect(page).to have_content(@address_1.state)
        expect(page).to have_content(@address_1.zip)
        expect(page).to have_content(@address_1.nickname)
      end
      within("#address-#{@address_2.id}") do
        expect(page).to have_content(@address_2.address_line)
        expect(page).to have_content(@address_2.city)
        expect(page).to have_content(@address_2.state)
        expect(page).to have_content(@address_2.zip)
        expect(page).to have_content(@address_2.nickname)
      end
      within("#address-#{@address_3.id}") do
        expect(page).to have_content(@address_3.address_line)
        expect(page).to have_content(@address_3.city)
        expect(page).to have_content(@address_3.state)
        expect(page).to have_content(@address_3.zip)
        expect(page).to have_content(@address_3.nickname)
      end
    end
  end
end

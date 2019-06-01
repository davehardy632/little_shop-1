require 'rails_helper'

describe "User can edit an address from their address page in their profile" do
  before :each do
    @user = create(:user)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      @address_1 = @user.addresses.create(address_line: "1211 west 16th st", city: "Denver", state: "CO", zip: "80104",  nickname: "Home")
      @address_2 = @user.addresses.create(address_line: "2033 north larimer st", city: "Chicago", state: "IL", zip: "80204", nickname: "Work")
      @address_3 = @user.addresses.create(address_line: "2244 blake st", city: "Boston", state: "MA", zip: "80304", nickname: "Other")
  end
  describe "When I visit my addresses and click edit address" do
    describe "I am taken to a form where I can edit all address info" do
      it "I click update address and the updated info is saved to my addresses index page" do

        visit profile_addresses_path

        within("#address-#{@address_1.id}") do
          click_link "Edit Address"
        end
        expect(current_path).to eq(edit_profile_address_path)

        fill_in "Address line", with: "5452 New Address Lane"
        fill_in "City", with: @address_1.city
        fill_in "State", with: @address_1.state
        fill_in "Zip", with: @address_1.zip
        fill_in "Nickname", with: @address_1.nickname
        click_on "Update Address"

        expect(current_path).to eq(profile_addresses_path)

        @address_1.reload

        within("#address-#{@address_1.id}") do
          expect(page).to have_content("5452 New Address Lane")
          expect(page).to have_content(@address_1.city)
          expect(page).to have_content(@address_1.state)
          expect(page).to have_content(@address_1.zip)
          expect(page).to have_content(@address_1.nickname)
        end
      end
    end
  end
end

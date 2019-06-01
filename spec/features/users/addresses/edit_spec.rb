require 'rails_helper'

describe "User can edit an address from their address page in their profile" do
  before :each do

    @user = create(:user)
    login_as(@user)
      @address_1 = @user.addresses.create(address_line: "1211 west 16th st", city: "Denver", state: "CO", zip: "80104",  nickname: "Home")
      @updated_address_line = "5452 New Address Lane"
      @updated_city = "Austin"
      @updated_state = "TX"
      @updated_zip = "50221"
      @updated_nickname = "Vacation Home"

    visit profile_addresses_path
    within("#address-#{@address_1.id}") do
      click_link "Edit Address"
    end
  end


  describe "When I visit my addresses and click edit address" do
    describe "I am taken to a form where I can edit all address info" do
      it "I click update address and the updated info is saved to my addresses index page" do

        expect(current_path).to eq(edit_profile_address_path(@address_1))

        fill_in "Address line", with: @updated_address_line
        fill_in "City", with: @updated_city
        fill_in "State", with: @updated_state
        fill_in "Zip", with: @updated_zip
        fill_in "Nickname", with: @updated_nickname
        click_on "Update Address"

        expect(current_path).to eq(profile_addresses_path)

        within("#address-#{@address_1.id}") do
          expect(page).to have_content(@updated_address_line)
          expect(page).to have_content(@updated_city)
          expect(page).to have_content(@updated_state)
          expect(page).to have_content(@updated_zip)
          expect(page).to have_content(@updated_nickname)
        end
      end
    end
    describe "Happy path" do
      it "Has form prepopulated with address data" do
        expect(current_path).to eq(edit_profile_address_path(@address_1))

        expect(page).to have_css("[@value='#{@address_1.address_line}']")
        expect(page).to have_css("[@value='#{@address_1.city}']")
        expect(page).to have_css("[@value='#{@address_1.state}']")
        expect(page).to have_css("[@value='#{@address_1.zip}']")
        expect(page).to have_css("[@value='#{@address_1.nickname}']")
      end
    end

    describe "Sad path" do
      it "cannot leave fields blank" do
        fill_in "Address line", with: ""
        fill_in "City", with: ""
        fill_in "State", with: ""
        fill_in "Zip", with: ""
        fill_in "Nickname", with: ""
        click_on "Update Address"

        expect(page).to have_content("Address line can't be blank")
        expect(page).to have_content("City can't be blank")
        expect(page).to have_content("State can't be blank")
        expect(page).to have_content("Zip can't be blank")
        expect(page).to have_content("Nickname can't be blank")
      end
      it "prepopulates fields when update is unsucessfull" do
        fill_in "Address line", with: ""
        fill_in "City", with: ""
        fill_in "State", with: ""
        fill_in "Zip", with: ""
        fill_in "Nickname", with: ""
        click_on "Update Address"

        expect(page).to have_css("[@value='#{@address_1.address_line}']")
        expect(page).to have_css("[@value='#{@address_1.city}']")
        expect(page).to have_css("[@value='#{@address_1.state}']")
        expect(page).to have_css("[@value='#{@address_1.zip}']")
        expect(page).to have_css("[@value='#{@address_1.nickname}']")
      end
    end
  end
end

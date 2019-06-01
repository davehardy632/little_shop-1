require 'rails_helper'

describe "User can delete an address from their address page in their profile" do
  before :each do

    @user = create(:user)
    login_as(@user)
      @address_1 = @user.addresses.create(address_line: "1211 west 16th st", city: "Denver", state: "CO", zip: "80104",  nickname: "Work")
      @address_2 = @user.addresses.create(address_line: "2033 north larimer st", city: "Chicago", state: "IL", zip: "80204", nickname: "Home")
      @address_3 = @user.addresses.create(address_line: "2244 blake st", city: "Boston", state: "MA", zip: "80304", nickname: "Other")

    visit profile_addresses_path
    within("#address-#{@address_1.id}") do
      click_link "Delete Address"
    end
  end

  describe "Happy Path" do
    it "When clicking delete, the address no longer appears and a flash message is displayed" do

      expect(page).to have_content("Address has been deleted")

      expect(page).to_not have_content(@address_1.address_line)
      expect(page).to_not have_content(@address_1.city)
      expect(page).to_not have_content(@address_1.state)
      expect(page).to_not have_content(@address_1.zip)
      expect(page).to_not have_content(@address_1.nickname)
    end
  end
end

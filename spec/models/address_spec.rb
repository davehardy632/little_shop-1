require 'rails_helper'

describe Address do
  describe "Validations" do
    it {should validate_presence_of :address }
    it {should validate_presence_of :city }
    it {should validate_presence_of :state }
    it {should validate_presence_of :zip }
    # it {should validate_presence_of :nickname }
  end
  describe "relationships" do
    it {should belong_to :user}
  end
end

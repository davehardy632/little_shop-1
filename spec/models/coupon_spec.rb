require 'rails_helper'

describe Coupon do
  describe "Validations" do
    it {should validate_uniqueness_of :name}
    it {should validate_numericality_of :discount}
    it

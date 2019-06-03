class Coupon < ApplicationRecord
  belongs_to :user
  validates_uniqueness_of :name
  validates_numericality_of :discount

end

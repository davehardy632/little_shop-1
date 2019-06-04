class Coupon < ApplicationRecord
  belongs_to :user
  has_many :orders
  validates_uniqueness_of :name
  validates_numericality_of :discount

end

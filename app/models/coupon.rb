class Coupon < ApplicationRecord
  belongs_to :user
  has_many :orders, dependent: :destroy
  validates_uniqueness_of :name
  validates_numericality_of :discount

end

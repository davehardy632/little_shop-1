class Address < ApplicationRecord
  belongs_to :user
  has_many :orders
  validates_presence_of :address
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip
  # validates_presence_of :nickname
end

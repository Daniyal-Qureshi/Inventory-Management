class Address < ApplicationRecord
  validates :recipient, :street_1, :city, :state, :zip, presence: true
end

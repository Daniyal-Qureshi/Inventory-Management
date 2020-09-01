class Product < ApplicationRecord
  validates :name, presence: true
  monetize :price_cents
end

class Product < ApplicationRecord
  validates :name, presence: true
  monetize :price_cents
  has_many :inventory

  def in_stock_count
    inventory.on_shelf.count
  end
end

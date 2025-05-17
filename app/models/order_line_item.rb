class OrderLineItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  validates :quantity, numericality: { greater_than: 0 }

  def cost
    quantity * product.price
  end

  def on_shelf_quantity
    product.on_shelf
  end

  def fulfillable?
    on_shelf_quantity >= quantity
  end
end

class Order < ApplicationRecord
  belongs_to :ships_to, class_name: 'Address'
  has_many :line_items, class_name: 'OrderLineItem'

  def cost
    line_items.inject(Money.zero) do |acc, li|
      acc + li.cost
    end
  end

  def fulfilled?
    Inventory.where(order_id: id).any?
  end

  def fulfillable?
    line_items.all?(&:fulfillable?)
  end
end

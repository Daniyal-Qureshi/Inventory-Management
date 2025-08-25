class FindFulfillableOrder
  def self.begin_fulfillment(employee)
    fulfill(employee, Order.fulfillable.first)
  end

  def self.fulfill_order(employee, order_id)
    fulfill(employee, Order.fulfillable.where(id: order_id).first)
  end

  def self.fulfill(employee, order)
    if order
      order.line_items.each do |line_item|
        inventory_items = Inventory.on_shelf.where(product: line_item.product).limit(line_item.quantity)
        ShipInventory.run(employee, inventory_items, order)
      end
    end
  end
  private_class_method :fulfill
end

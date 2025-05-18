class ReturnOrder
  def self.run(employee, order)
    new(employee: employee, order: order).run
  end

  def initialize(employee:, order:)
    @employee = employee
    @order = order
    @product_counts = Hash.new(0)
  end

  def run
    Inventory.transaction do
      order.inventories.each do |inventory|
        return_inventory(inventory)
        @product_counts[inventory.product_id] += 1
      end
      
      @product_counts.each do |product_id, quantity|
        ReturnedOrderHistory.create!(
          order: order,
          product_id: product_id,
          quantity: quantity
        )
      end
    end    
    true
  end

  private

  attr_reader :employee, :order

  def return_inventory(inventory)
    inventory.with_lock do
      InventoryStatusChange.create!(
        inventory: inventory,
        status_from: inventory.status,
        status_to: :returned,
        actor: employee
      )
      inventory.update!(status: :returned)
    end
  end
end 
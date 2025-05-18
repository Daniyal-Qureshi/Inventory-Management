class ShipInventory
  def self.run(employee, inventory_items, order)
    new(employee:, inventory_items:, order:).run
  end

  def initialize(employee:, inventory_items:, order:)
    @employee = employee
    @inventory_items = inventory_items
    @order = order
  end

  def run
    product_ids = Set.new

    Inventory.transaction do
      inventory_items.each do |inventory|
        ship_inventory(inventory)
        product_ids << inventory.product_id
      end
    end

    product_ids.each do |product_id|
      Product.find(product_id).update_on_shelf_counter
    end
  end

  private

  attr_reader :employee, :inventory_items, :order

  def ship_inventory(inventory)
    inventory.with_lock do
      InventoryStatusChange.create!(
        inventory:,
        status_from: inventory.status,
        status_to: :shipped,
        actor: employee
      )
      inventory.update!(status: :shipped, order:)
    end
  end
end

class ShipInventory
  def self.run(employee, inventory_items)
    new(employee: employee, inventory_items: inventory_items).run
  end

  def initialize(employee:, inventory_items:)
    @employee = employee
    @inventory_items = inventory_items
  end

  def run
    Inventory.transaction do
      inventory_items.each do |inventory|
        ship_inventory(inventory)
      end
    end
  end

  private

  attr_reader :employee, :inventory_items

  def ship_inventory(inventory)
    inventory.with_lock do
      InventoryStatusChange.create!(
        inventory: inventory,
        status_from: inventory.status,
        status_to: :shipped,
        actor: employee
      )
      inventory.update!(status: :shipped)
    end
  end
end

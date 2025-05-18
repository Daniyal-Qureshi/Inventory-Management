class RestockReturnedProduct
  def self.run(employee, product)
    new(employee: employee, product: product).run
  end

  def initialize(employee:, product:)
    @employee = employee
    @product = product
  end

  def run
    returned_inventories = Inventory.where(product: product, status: :returned)
    
    return false if returned_inventories.empty?
    
    Inventory.transaction do
      returned_inventories.each do |inventory|
        restock_inventory(inventory)
      end
    end
    
    product.update_on_shelf_counter
    true
  end

  private

  attr_reader :employee, :product

  def restock_inventory(inventory)
    inventory.with_lock do
      InventoryStatusChange.create!(
        inventory: inventory,
        status_from: inventory.status,
        status_to: :on_shelf,
        actor: employee
      )
      inventory.update!(status: :on_shelf, order_id: nil)
    end
  end
end 
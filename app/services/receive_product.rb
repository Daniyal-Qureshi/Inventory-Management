class ReceiveProduct
  def self.run(employee, product, quantity)
    new(employee:, product:, quantity:).run
  end

  def initialize(employee:, product:, quantity:)
    @employee = employee
    @product = product
    @quantity = quantity
  end

  def run
    Inventory.transaction do
      quantity.times do
        create_inventory
      end
    end
  end

  private

  attr_reader :employee, :product, :quantity

  def create_inventory
    inventory = Inventory.create!(product:, status: :on_shelf)
    InventoryStatusChange.create!(
      inventory:,
      status_from: nil,
      status_to: :on_shelf,
      actor: employee
    )
  end
end

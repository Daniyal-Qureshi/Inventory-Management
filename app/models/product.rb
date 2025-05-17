class Product < ApplicationRecord
  validates :name, presence: true
  monetize :price_cents
  has_many :inventory
  
  def needed_inventory_count
    self.class.connection.select_value(<<~SQL)
      SELECT GREATEST(
        SUM(order_line_items.quantity) - #{on_shelf}, 0)
      FROM order_line_items
        LEFT OUTER JOIN inventories
          ON order_line_items.order_id = inventories.order_id
      WHERE order_line_items.product_id = #{id}
        AND inventories.order_id IS NULL
    SQL
  end

  def update_on_shelf_counter
    with_lock do
      count = Inventory.on_shelf.where(product_id: id).count
      update_column(:on_shelf, count)
    end
  end
end

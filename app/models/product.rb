class Product < ApplicationRecord
  validates :name, presence: true
  monetize :price_cents
  has_many :inventory

  def in_stock_count
    inventory.on_shelf.count
  end

  def needed_inventory_count
    self.class.connection.select_value(<<~SQL)
      SELECT GREATEST(
        SUM(order_line_items.quantity) - (
          SELECT quantity FROM product_on_shelf_quantities WHERE product_id = #{id}
        ), 0)
      FROM order_line_items
        LEFT OUTER JOIN inventories
          ON order_line_items.order_id = inventories.order_id
      WHERE order_line_items.product_id = #{id}
        AND inventories.order_id IS NULL
    SQL
  end
end

class NeededInventoryQuery
  def initialize(product)
    @product = product
  end

  def quantity
    ActiveRecord::Base.connection.exec_query(arel.to_sql).first['greatest']
  end

  private

  attr_reader :product

  def arel
    products = Product.arel_table
    order_line_items = OrderLineItem.arel_table

    products
      .project(greatest(order_line_items[:quantity].sum - inventory_counts[:quantity], 0))
      .join(inventory_counts, Arel::Nodes::OuterJoin)
      .on(inventory_counts[:product_id].eq(products[:id]))
      .join(order_line_items, Arel::Nodes::OuterJoin)
      .on(order_line_items[:product_id].eq(products[:id]))
      .where(products[:id].eq(product.id))
      .group(products[:id], inventory_counts[:quantity])
      .order(products[:id])
  end

  def inventory_counts
    inventories = Inventory.arel_table

    inventories
      .project(inventories[:product_id], inventories[:product_id].count.as('quantity'))
      .group(inventories[:product_id])
      .as('inventory_counts')
  end

  def greatest(*args)
    Arel::Nodes::NamedFunction.new 'greatest', args
  end
end

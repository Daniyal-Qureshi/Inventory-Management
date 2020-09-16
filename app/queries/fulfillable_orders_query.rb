class FulfillableOrdersQuery
  delegate :first, :each, to: :records

  def find(id)
    Order.find_by_sql(
      arel.where(Order.arel_table[:id].eq(id)).to_sql
    ).first
  end

  def limit(value)
    Order.find_by_sql(
      arel.take(value).to_sql
    )
  end

  private

  def records
    Order.find_by_sql(arel.to_sql)
  end

  def arel
    orders = Order.arel_table
    product_on_shelf_quantities = ProductOnShelfQuantity.arel_table
    order_line_items = OrderLineItem.arel_table

    orders
      .project(orders[Arel.star])
      .join(order_line_items)
      .on(order_line_items[:order_id].eq(orders[:id]))
      .join(product_on_shelf_quantities, Arel::Nodes::OuterJoin)
      .on(enough_products_are_on_shelf)
      .where(order_is_not_fulfilled)
      .group(orders[:id])
      .having(all_ordered_items_are_available)
      .order(orders[:created_at], orders[:id])
  end

  def enough_products_are_on_shelf
    product_on_shelf_quantities = ProductOnShelfQuantity.arel_table
    order_line_items = OrderLineItem.arel_table

    product_on_shelf_quantities[:product_id].eq(order_line_items[:product_id]).and(
      product_on_shelf_quantities[:quantity].gteq(order_line_items[:quantity])
    )
  end

  def order_is_not_fulfilled
    inventories = Inventory.arel_table
    orders = Order.arel_table
    inventories.project.where(inventories[:order_id].eq(orders[:id])).exists.not
  end

  def all_ordered_items_are_available
    product_on_shelf_quantities = ProductOnShelfQuantity.arel_table
    order_line_items = OrderLineItem.arel_table

    product_on_shelf_quantities[:product_id].count(distinct: true).eq(
      order_line_items[:product_id].count(distinct: true)
    )
  end
end

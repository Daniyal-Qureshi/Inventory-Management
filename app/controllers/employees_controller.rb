class EmployeesController < ApplicationController
  before_action :require_signin, :require_warehouse_employee

  def index
    @fulfillable_orders = Order.fulfillable.limit(10)
    @recent_orders = Order.recent.limit(10)
    @products = Product.all
    @fulfilled_orders = Order.fulfilled.limit(10)
    @returned_orders = Order.with_returned_items
    @returned_products = Inventory.returned_products
  end
end

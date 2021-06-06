class EmployeesController < ApplicationController
  before_action :require_signin

  def index
    @fulfillable_orders = Order.fulfillable.limit(10)
    @recent_orders = Order.recent.limit(10)
    @products = Product.all
  end
end

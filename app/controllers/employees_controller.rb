class EmployeesController < ApplicationController
  before_action :require_signin

  def index
    @fulfillable_orders = FulfillableOrdersQuery.new.limit(10)
    @recent_orders = RecentOrdersQuery.new.limit(10)
    @products = Product.all
  end
end

class CustomerServiceController < ApplicationController
  before_action :require_customer_service_employee

  def index
    @orders_with_issues = Order.with_address_issues.includes(:ships_to)
  end
end

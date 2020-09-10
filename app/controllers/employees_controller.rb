class EmployeesController < ApplicationController
  before_action :require_signin

  def index
    @recent_orders = RecentOrdersQuery.new.limit(10)
  end
end

class ReturnsController < ApplicationController
  before_action :require_warehouse_employee
  before_action :set_order, only: %i[create show]

  def create
    ReturnOrder.run(current_user, @order)

    redirect_to employees_path, notice: 'Order marked as returned'
  end

  def show
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end
end

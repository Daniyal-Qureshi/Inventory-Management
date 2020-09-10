class FulfillsController < ApplicationController
  def create
    FindFulfillableOrder.fulfill_order(current_user, params[:order_id])

    redirect_to employees_path
  end
end

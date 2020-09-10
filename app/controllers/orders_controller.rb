class OrdersController < ApplicationController
  before_action :require_signin

  def show
    @order = Order.find(params[:id])
  end
end

class ProductsController < ApplicationController
  def index
    @products = Product.includes(:inventory).order(id: :asc)
  end
end

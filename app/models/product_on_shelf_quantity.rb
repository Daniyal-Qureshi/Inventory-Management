class ProductOnShelfQuantity < ApplicationRecord
  belongs_to :product

  def readonly?
    true
  end
end

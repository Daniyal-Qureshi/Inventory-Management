class Inventory < ApplicationRecord
  enum status: InventoryStatusChange::STATUSES
  belongs_to :product
  belongs_to :order, required: false

  validates :product, presence: true

  scope :on_shelf, -> { where(status: :on_shelf) }
  scope :returned, -> { where(status: :returned) }
  scope :shipped, -> { where(status: :shipped) }
  scope :returned_by_product, ->(product_id) { returned.where(product_id: product_id) }
  
  def self.returned_products
    returned_products = {}
    Inventory.returned.includes(:product).each do |inventory|
      product = inventory.product
      returned_products[product] ||= 0
      returned_products[product] += 1
    end
    returned_products.sort_by { |product, _| product.name }
  end
end

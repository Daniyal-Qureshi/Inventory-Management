class Inventory < ApplicationRecord
  enum status: InventoryStatusChange::STATUSES
  belongs_to :product
  belongs_to :order, required: false

  validates :product, presence: true
end

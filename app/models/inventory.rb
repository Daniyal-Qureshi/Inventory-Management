class Inventory < ApplicationRecord
  enum status: InventoryStatusChange::STATUSES
  belongs_to :product

  validates :product, presence: true
end

class InventoryStatusChange < ApplicationRecord
  STATUSES = {
    on_shelf: 'on_shelf',
    shipped: 'shipped',
    returned: 'returned'
  }.freeze

  belongs_to :inventory
  belongs_to :actor, class_name: 'Employee'

  enum status_from: STATUSES, _prefix: :from
  enum status_to: STATUSES, _prefix: :to

  validates :status_to, presence: true
end

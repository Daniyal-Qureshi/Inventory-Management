class Order < ApplicationRecord
  belongs_to :ships_to, class_name: 'Address'
  has_many :line_items, class_name: 'OrderLineItem'
  has_many :inventories
  has_many :returned_order_histories

  scope :recent, -> { order(created_at: :desc) }
  scope :fulfilled, -> { joins(:inventories).merge(Inventory.shipped).group('orders.id') }
  scope :not_fulfilled, -> { left_joins(:inventories).where(inventories: { order_id: nil }) }
  scope :with_returned_items, lambda {
    joins(:returned_order_histories).distinct
  }
  scope :with_address_issues, -> { with_returned_items.where(address_fixed: false) }
  scope :fulfillable, lambda {
    not_fulfilled
      .joins(:line_items)
      .joins(<<~SQL)
        LEFT OUTER JOIN products
          ON order_line_items.product_id = products.id
         AND order_line_items.quantity <= products.on_shelf
      SQL
      .group(:id)
      .having(<<~SQL)
        COUNT(DISTINCT products.id) =
        COUNT(DISTINCT order_line_items.product_id)
      SQL
      .order(:created_at, :id)
  }

  def cost
    line_items.inject(Money.zero) do |acc, li|
      acc + li.cost
    end
  end

  def fulfilled?
    return false if inventories.empty?

    inventories.each do |inventory|
      if inventory.status != 'shipped'
        return false
      end
    end
    true
  end

  def returned?
    ReturnedOrderHistory.exists?(order_id: id)
  end

  # bug: An order which has already been fulfilled or returned is being considered as fulfillable.
  # it can be fixed as follow:
  #   def fulfillable?
  #     !fulfilled? && !returned? && line_items.all?(&:fulfillable?)
  #   end

  def fulfillable?
    line_items.all?(&:fulfillable?)
  end

  def mark_address_as_fixed!
    update!(address_fixed: true)
  end
end

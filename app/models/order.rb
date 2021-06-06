class Order < ApplicationRecord
  belongs_to :ships_to, class_name: 'Address'
  has_many :line_items, class_name: 'OrderLineItem'
  has_many :inventories

  scope :recent, -> { order(created_at: :desc) }
  scope :fulfilled, -> { joins(:inventories).group('orders.id') }
  scope :not_fulfilled, -> { left_joins(:inventories).where(inventories: { order_id: nil }) }
  scope :fulfillable, lambda {
    not_fulfilled
      .joins(:line_items)
      .joins(<<~SQL)
        LEFT OUTER JOIN product_on_shelf_quantities
          ON order_line_items.product_id = product_on_shelf_quantities.product_id
         AND order_line_items.quantity <= product_on_shelf_quantities.quantity
      SQL
      .group(:id)
      .having(<<~SQL)
        COUNT(DISTINCT product_on_shelf_quantities.product_id) =
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
    inventories.any?
  end

  def fulfillable?
    line_items.all?(&:fulfillable?)
  end
end

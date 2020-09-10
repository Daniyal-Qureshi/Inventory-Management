class FulfilledOrdersQuery
  def initialize(scope = Order)
    @scope = scope
  end

  delegate :empty?, :include?, :to_a, to: :records

  private

  attr_reader :scope

  def records
    scope.where(id: Inventory.pluck(:order_id).uniq)
  end
end

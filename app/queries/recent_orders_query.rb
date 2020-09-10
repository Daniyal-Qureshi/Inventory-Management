class RecentOrdersQuery
  def initialize(scope: Order)
    @scope = scope
  end

  delegate :each, :limit, to: :records

  private

  attr_reader :scope

  def records
    scope.order(created_at: :desc)
  end
end

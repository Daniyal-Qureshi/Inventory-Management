class DevSeed
  PRICINGS = {
    '3x5' => Money.new(499, 'USD'),
    '4x6' => Money.new(999, 'USD'),
    '5x7' => Money.new(1899, 'USD'),
    '8x10' => Money.new(2899, 'USD')
  }.freeze

  COLORS = %w[Gold Silver Bronze].freeze

  EMPLOYEES = {
    'Serafina Makarova' => '10000',
    'Izzet Ayhan' => '10001',
    'Beatriz Arroyo' => '10002',
    'Azizi Soyinka' => '10003',
    'Rafi Yousef' => '10004',
    'Erin McDonnell' => '10005'
  }.freeze

  def self.run
    new.run
  end

  def run
    create_products
    create_employees
    create_inventory
    ship_in_stock_inventory
  end

  private

  def create_products
    PRICINGS.each do |size, price|
      COLORS.each do |color|
        Product.create!(name: "#{color} #{size} Picture Frame", price: price)
      end
    end
  end

  def create_employees
    EMPLOYEES.each do |name, access_code|
      Employee.create!(name: name, access_code: access_code)
    end
  end

  def create_inventory
    100.times do
      ReceiveProduct.run(random_employee, random_product, rand(5))
    end
  end

  def random_employee
    Employee.order('RANDOM()').first
  end

  def random_product
    Product.order('RANDOM()').first
  end

  def ship_in_stock_inventory
    5.times do
      ShipInventory.run(
        random_employee,
        Inventory.on_shelf.order('RANDOM()').limit(rand(5))
      )
    end
  end
end

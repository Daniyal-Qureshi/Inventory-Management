class DevSeed
  ORDER_COUNT = 200
  ADDRESS_COUNT = 30
  RECEIVED_PRODUCT_COUNT = 300
  RECEIVED_PRODUCT_INVENTORY_COUNT = 10
  MAXIMUM_LINE_ITEM_ORDER_QUANTITY = 10
  MAXIMUM_LINE_ITEMS_PER_ORDER = 7

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
    create_customer_addresses
    create_inventory
    create_orders
    ship_in_stock_inventory
  end

  def create_order(address)
    Order.transaction do
      order = Order.create!(ships_to: address)

      random_products_for_order.each do |product|
        order.line_items.create!(
          product: product,
          quantity: rand(MAXIMUM_LINE_ITEM_ORDER_QUANTITY) + 1
        )
      end
    end
  end

  def create_address
    Address.create!(
      recipient: Faker::Name.name,
      street_1: Faker::Address.street_address,
      street_2: Faker::Address.secondary_address,
      city: Faker::Address.city,
      state: Faker::Address.state_abbr,
      zip: Faker::Address.zip_code
    )
  end

  def random_address
    Address.order('RANDOM()').first
  end

  def create_products
    PRICINGS.each do |size, price|
      COLORS.each do |color|
        Product.create!(name: "#{color} #{size} Picture Frame", price: price)
      end
    end
  end

  private

  def create_employees
    EMPLOYEES.each do |name, access_code|
      Employee.create!(name: name, access_code: access_code)
    end
  end

  def create_inventory
    RECEIVED_PRODUCT_COUNT.times do
      ReceiveProduct.run(random_employee, random_product, RECEIVED_PRODUCT_INVENTORY_COUNT)
    end
  end

  def random_employee
    Employee.order('RANDOM()').first
  end

  def random_product
    Product.order('RANDOM()').first
  end

  def ship_in_stock_inventory
    while (order = FulfillableOrdersQuery.new.first).present?
      FindFulfillableOrder.fulfill_order(random_employee, order.id)
    end
  end

  def create_customer_addresses
    ADDRESS_COUNT.times do
      create_address
    end
  end

  def create_orders
    ORDER_COUNT.times do
      create_order(random_address)
    end
  end

  def random_products_for_order
    (rand(MAXIMUM_LINE_ITEMS_PER_ORDER) + 1).times.map { random_product }.uniq
  end
end

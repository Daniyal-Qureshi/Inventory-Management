require_relative 'dev_seed'

class DevSimulation
  SIMULATION = {
    tick_seconds: 15,
    repeat_customer_likelihood: 0.5,
    new_order_likelihood: 0.4
  }.freeze

  def self.simulate_platform_use
    new(**SIMULATION).simulate_platform_use
  end

  def initialize(tick_seconds:, repeat_customer_likelihood:, new_order_likelihood:)
    @tick_seconds = tick_seconds
    @repeat_customer_likelihood = repeat_customer_likelihood
    @new_order_likelihood = new_order_likelihood
    @seed = DevSeed.new
  end

  def simulate_platform_use
    ensure_products_exist

    loop do
      if process_simulation_tick? && create_order?
        seed.create_order(address)
      end

      sleep tick_seconds
    end
  end

  private

  attr_reader :tick_seconds, :repeat_customer_likelihood, :new_order_likelihood, :seed

  def ensure_products_exist
    if Product.count.zero?
      seed.create_products
    end
  end

  def process_simulation_tick?
    ENV.fetch('ENABLE_SIMULATION', 'true').downcase == 'true'
  end

  def create_order?
    rand >= (1 - new_order_likelihood)
  end

  def address
    if rand >= (1 - repeat_customer_likelihood)
      seed.random_address || seed.create_address
    else
      seed.create_address
    end
  end
end

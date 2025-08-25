require 'rails_helper'
require 'dev_simulation'

RSpec.describe DevSimulation do
  it 'honors always repeat customer settings' do
    run_sim(tick_seconds: 2, repeat_customer_likelihood: 1, new_order_likelihood: 1, duration: 5)

    expect(Order.count).to eq 3
    expect(Address.count).to eq 1
  end

  it 'honors no repeat customer settings' do
    run_sim(tick_seconds: 2, repeat_customer_likelihood: 0, new_order_likelihood: 1, duration: 5)

    expect(Order.count).to eq 3
    expect(Address.count).to eq 3
  end

  it 'honors never creating orders' do
    run_sim(tick_seconds: 2, repeat_customer_likelihood: 1, new_order_likelihood: 0, duration: 1)

    expect(Order.count).to eq 0
  end

  it 'honors tick frequency' do
    run_sim(tick_seconds: 3, repeat_customer_likelihood: 1, new_order_likelihood: 1, duration: 2)

    expect(Order.count).to eq 1
  end

  def run_sim(tick_seconds:, repeat_customer_likelihood:, new_order_likelihood:, duration:)
    sim = DevSimulation.new(tick_seconds:,
                            repeat_customer_likelihood:,
                            new_order_likelihood:)

    thread = Thread.new { sim.simulate_platform_use }

    sleep duration

    Thread.kill(thread)
  end
end

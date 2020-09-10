require 'rails_helper'

RSpec.feature 'Employee fulfills order' do
  scenario 'successfully' do
    product = create(:product)
    employee = create(:employee, name: 'Jane Doe', access_code: '41315')
    ReceiveProduct.run(employee, product, 10)
    order = create(:order)
    create(:order_line_item, order: order, product: product, quantity: 5)

    visit root_path
    click_on sign_in
    attempt_code('41315')

    expect(page).to have_unfulfilled_order(order)
    view_order(order)
    fulfill_order
    expect(page).to have_fulfilled_order(order)

    view_order(order)
    expect(page).not_to allow_fulfillment
  end

  def have_unfulfilled_order(order)
    have_css("[data-id=order-#{order.id}]", text: 'Unfulfilled')
  end

  def have_fulfilled_order(order)
    have_css("[data-id=order-#{order.id}]", text: 'Fulfilled')
  end

  def view_order(order)
    find("[data-id=order-#{order.id}] a").click
  end

  def fulfill_order
    click_on(t('orders.show.fulfill_order'))
  end

  def allow_fulfillment
    have_css('button:not(:disabled)')
  end
end

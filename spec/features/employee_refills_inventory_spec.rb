require 'rails_helper'

RSpec.feature 'Employee refills inventory' do
  scenario 'successfully' do
    product = create(:product)
    employee = create(:employee, name: 'Jane Doe', access_code: '41315')
    ReceiveProduct.run(employee, product, 5)
    order = create(:order)
    create(:order_line_item, order:, product:, quantity: 25)

    visit root_path
    click_on sign_in
    attempt_code('41315')

    expect(page).to have_unfulfillable_order(order)

    view_order(order)
    expect(page).not_to allow_fulfillment

    visit employees_path

    refill_inventory(product, 20)

    expect(page).to have_fulfillable_order(order)

    view_order(order)
    fulfill_order

    expect(page).to have_fulfilled_order(order)
  end

  def refill_inventory(product, quantity)
    within("[data-id='product-#{product.id}'] form") do
      fill_in I18n.t('helpers.label.receive_product.quantity'), with: quantity
      click_on I18n.t('helpers.submit.receive_product.submit')
    end
  end
end

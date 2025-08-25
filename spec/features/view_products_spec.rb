require 'rails_helper'

RSpec.feature 'View products' do
  scenario 'successfully' do
    small_product = create(:product, name: '4x6 Picture Frame', price: build(:amount, :small))
    medium_product = create(:product, name: '5x7 Picture Frame', price: build(:amount, :medium))
    large_product = create(:product, name: '8x10 Picture Frame', price: build(:amount, :large))

    employee = create(:employee)

    ReceiveProduct.run(employee, small_product, 3)
    ReceiveProduct.run(employee, medium_product, 1)
    ReceiveProduct.run(employee, large_product, 2)

    visit root_path

    small_frame_on_page = ProductOnPage.new('4x6 Picture Frame')
    medium_frame_on_page = ProductOnPage.new('5x7 Picture Frame')
    large_frame_on_page = ProductOnPage.new('8x10 Picture Frame')

    expect(small_frame_on_page).to have_display_name
    expect(small_frame_on_page).to be_priced_at(build(:amount, :small))
    expect(small_frame_on_page).to have_in_stock(3)

    expect(medium_frame_on_page).to have_display_name
    expect(medium_frame_on_page).to be_priced_at(build(:amount, :medium))
    expect(medium_frame_on_page).to have_in_stock(1)

    expect(large_frame_on_page).to have_display_name
    expect(large_frame_on_page).to be_priced_at(build(:amount, :large))
    expect(large_frame_on_page).to have_in_stock(2)

    expect(page).to have_css('.product', count: 3)
  end

  def display_product(name)
    have_css('.product__header', text: name)
  end
end

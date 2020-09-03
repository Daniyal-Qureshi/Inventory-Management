ProductOnPage = Struct.new(:name) do
  include Capybara::DSL
  include MoneyRails::ActionViewExtension

  def has_display_name?
    product_element.has_css?('.product__header', text: name)
  end

  def priced_at?(price)
    product_element.has_css?('.product__price', text: humanized_money_with_symbol(price))
  end

  private

  def product
    @product ||= Product.find_by!(name: name)
  end

  def product_element
    find("[data-id=product-#{product.id}]")
  end
end

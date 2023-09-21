require 'money-rails/helpers/action_view_extension'

ProductOnPage = Struct.new(:name) do
  include Capybara::DSL
  include MoneyRails::ActionViewExtension

  def has_display_name?
    product_element.has_css?('.product__header', text: name)
  end

  def priced_at?(price)
    product_element.has_css?('.product__price', text: humanized_money_with_symbol(price))
  end

  def sold_out?
    product_element.has_css?('.product__quantity', text: I18n.t('.products.index.quantity.zero'))
  end

  def has_in_stock?(count)
    product_element.has_css?('.product__quantity', text: I18n.t('.products.index.quantity', count:))
  end

  private

  def product
    @product ||= Product.find_by!(name:)
  end

  def product_element
    find("[data-id=product-#{product.id}]")
  end
end

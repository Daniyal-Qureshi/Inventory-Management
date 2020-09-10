module ApplicationHelper
  def order_status(order)
    if order.fulfilled?
      t('order.fulfilled')
    else
      t('order.unfulfilled')
    end
  end

  def order_status_class(order)
    if order.fulfilled?
      'bg-green-200 text-green-800'
    else
      'bg-red-200 text-red-800'
    end
  end

  def line_item_fulfillable_class(order, line_item)
    if !order.fulfilled?
      if line_item.fulfillable?
        'bg-green-100 text-green-800'
      else
        'bg-red-100 text-red-800'
      end
    end
  end

  def fulfill_order_button_class(order)
    if order.fulfillable?
      'bg-teal-600 text-white'
    else
      'bg-gray-500 text-gray-300 cursor-not-allowed'
    end
  end
end

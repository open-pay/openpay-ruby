require 'open_pay_resource'

class CheckoutsPe < OpenPayResource

  def create(checkout, customer_id = nil)
    amount = checkout[:amount].to_s.split('.')
    if amount.length > 0
      LOG.warn "The amount have decimals. Revoming.."
    end
    checkout[:amount] = amount[0]
    if customer_id
      customers = @api_hook.create(:customers)
      customers.create_checkout(customer_id, checkout)
    else
      super checkout
    end
  end

  def get(checkout_id = '', customer_id = nil)
    if customer_id
      customers = @api_hook.create(:customers)
      customers.get_checkout(customer_id, checkout_id)
    else
      super checkout_id
    end
  end

  def all(customer_id = nil)
    if customer_id
      customers = @api_hook.create(:customers)
      customers.all_checkouts(customer_id)
    else
      super ''
    end
  end

  def list(search_params, customer_id = nil)
    if customer_id
      customers = @api_hook.create(:customers)
      customers.list_checkouts(customer_id, search_params)
    else
      super search_params
    end
  end

  def get_by_order_id(order_id)
    url = @base_url + "#{@merchant_id}/orderId/#{order_id}/checkouts"
    get_with_custom_url(url)
  end

end

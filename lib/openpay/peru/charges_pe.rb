require 'open_pay_resource'

class ChargesPe < OpenPayResource

  def create(charge, customer_id = nil)
    amount = charge[:amount].to_s.split('.')
    if amount.length > 0
      LOG.warn "The amount have decimals. Revoming.."
    end
    charge[:amount] = amount[0]
    if customer_id
      customers = @api_hook.create(:customers)
      customers.create_charge(customer_id, charge)
    else
      super charge
    end
  end

  def all(customer_id = nil)
    if customer_id
      customers = @api_hook.create(:customers)
      customers.all_charges(customer_id)
    else
      super ''
    end
  end

  # def cancel(transaction_id, customer_id = nil)
  #   if customer_id
  #     customers = @api_hook.create(:customers)
  #     customers.cancel_charge(customer_id, transaction_id)
  #   else
  #     post('', transaction_id + '/cancel')
  #   end
  # end
  #
  # def refund(transaction_id, description, customer_id = nil)
  #   if customer_id
  #     customers = @api_hook.create(:customers)
  #     customers.refund_charge(customer_id, transaction_id, description)
  #   else
  #     post(description, transaction_id + '/refund')
  #   end
  # end

  def each(customer_id = nil)
    if customer_id
      all(customer_id).each do |card|
        yield card
      end
    else
      all.each do |card|
        yield card
      end
    end
  end

  def get(charge = '', customer_id = nil)
    if customer_id
      customers = @api_hook.create(:customers)
      customers.get_charge(customer_id, charge)
    else
      super charge
    end
  end

  def list(search_params, customer_id = nil)
    if customer_id
      customers = @api_hook.create(:customers)
      customers.list_charges(customer_id, search_params)
    else
      super search_params
    end
  end

end

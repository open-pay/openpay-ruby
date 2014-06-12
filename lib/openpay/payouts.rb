require 'open_pay_resource'

class Payouts < OpenPayResource

  def all(customer_id=nil)
    if customer_id
      customers=@api_hook.create(:customers)
      customers.all_payouts(customer_id)
    else
      super ''
    end
  end

  def get(payout='', customer_id=nil)
    if customer_id
      customers=@api_hook.create(:customers)
      customers.get_payout(customer_id, payout)
    else
      super payout
    end
  end

  def each(customer_id=nil)
    if customer_id
      customers=@api_hook.create(:customers)
      customers.each_payout(customer_id)  do |cust|
        yield cust
      end
    else
      all.each do |cust|
        yield cust
      end
    end
  end

  def create(payout, customer_id=nil)
    if customer_id
      customers=@api_hook.create(:customers)
      customers.create_payout(customer_id, payout)
    else
      super payout
    end
  end

  def list(search_params, customer_id=nil)
    if customer_id
      customers=@api_hook.create(:customers)
      customers.list_payouts(customer_id, search_params)
    else
      super search_params
    end
  end


end

require 'open_pay_resource'



class Payouts < OpenPayResource





  def all(customer_id=nil)
    if customer_id
      customers=@api_hook.create(:customers)
      customers.all_payouts(customer_id)
    else
      super   ''
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





  #TODO al parecer no se puede hacer pagos al merchantid
  def create(payout, customer_id=nil)
    if customer_id
      customers=@api_hook.create(:customers)
      customers.create_payout(customer_id, payout)
    else
      super payout
    end
  end




end
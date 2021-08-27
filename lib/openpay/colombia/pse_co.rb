class PseCo < OpenPayResource

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

end
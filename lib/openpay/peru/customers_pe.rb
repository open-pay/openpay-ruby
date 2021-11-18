require 'openpay/open_pay_resource'

class CustomersPe < OpenPayResource

  #Charges
  # customers.create_charge(customer_id,charge)
  def create_charge(customer_id, charge)
    create(charge, "#{customer_id}/charges")
  end

  #gets a charge_id for a given customer_id
  def get_charge(customer_id, charge_id)
    get("#{customer_id}/charges/#{charge_id}")
  end

  def list_charges(customer, search_params)
    get("#{customer}/charges#{search_params.to_s}")
  end


  #return all charges for the given customer_id
  def all_charges(customer_id)
    get("#{customer_id}/charges")
  end

  #Card
  def create_card(customer, card)
    create(card, "#{customer}/cards")
  end

  def get_card(customer, card_id)
    get("#{customer}/cards/#{card_id}")
  end

  def delete_card(customer, card_id)
    delete("#{customer}/cards/#{card_id}")
  end

  def delete_all_cards(customer_id)
    if env == :production
      raise OpenpayException.new('This method is not supported on PRODUCTION', false)
    end
    each_card(customer_id) do |card|
      delete_card(customer_id, card['id'])
    end
  end

  def each_card(customer)
    get("#{customer}/cards").each do |card|
      yield card
    end
  end

  def list_cards(customer, search_params)
    get("#{customer}/cards#{search_params.to_s}")
  end

  def all_cards(customer)
    get("#{customer}/cards")
  end

  # Checkouts
  def create_checkout(customer, checkout)
    create(checkout, "#{customer}/checkouts")
  end

  def get_checkout(customer_id, checkout_id)
    get("#{customer_id}/checkouts/#{checkout_id}")
  end

  def all_checkouts(customer_id)
    get("#{customer_id}/checkouts")
  end

  def list_checkouts(customer_id, search_params)
    get("#{customer_id}/checkouts#{search_params.to_s}")
  end

end

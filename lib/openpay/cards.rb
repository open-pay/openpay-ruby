require 'open_pay_resource'

class Cards < OpenPayResource

  def get(card='',customer_id=nil)
    if customer_id
      customers=@api_hook.create(:customers)
      customers.get_card(customer_id,card)
    else
      super card
    end
  end

  def create(card,customer_id=nil)
    if customer_id
      customers=@api_hook.create(:customers)
      customers.create_card(customer_id,card)
    else
      super card
    end
  end

  def delete(card_id,customer_id=nil)
    if customer_id
      customers=@api_hook.create(:customers)
      customers.delete_card(customer_id,card_id)
    else
      super card_id
    end
  end

  def delete_all(customer_id=nil)
    if customer_id
      customers=@api_hook.create(:customers)
      customers.delete_all_cards(customer_id)
    else
      each do |card|
        delete(card['id'])
      end
    end
  end

  def each(customer_id=nil)
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

  def all(customer_id=nil)
    if customer_id
      customers=@api_hook.create(:customers)
      customers.all_cards(customer_id)
    else
      super ''
    end
  end

  def list(search_params,customer_id=nil)
    if customer_id
      customers=@api_hook.create(:customers)
      customers.list_cards(customer_id,search_params)
    else
      super search_params
    end
  end

end

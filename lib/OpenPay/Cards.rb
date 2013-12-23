require 'open_pay_resource'

class Cards < OpenPayResource




  def list(creation,before,after,offset=0,limit=10)

  end



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


  def delete(card,customer_id=nil)
    if customer_id
      customers=@api_hook.create(:customers)
      customers.delete_card(customer_id,card)
    else
      super card
    end
  end



  def all(customer_id=nil)
    if customer_id
      customers=@api_hook.create(:customers)
      customers.all_cards(customer_id)
    else
      super   ''
    end
  end





end
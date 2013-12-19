require 'OpenPayResource'

class Cards < OpenPayResource


  def get_card(id)
     get(id)
  end


  def add_card(card,customer=nil)
    if customer
      customers=api_hook.create(:customers)
      customer=customers.get(customer)['id']

      add(card,"#{customer}/cards")


    else
      add(card)
    end
  end







end
require 'OpenPayResource'



#TODO relate Customers wtith related objects.


class Customers < OpenPayResource


  def get_customer(customer_id)
    get(customer_id)
  end



  def add_card(customer,card)
       add(card,"#{customer}/cards")
  end

  def each_card(customer)

       get("#{customer}/cards").each do |card|
           yield card
       end

  end


  def all_cards(customer)
    get("#{customer}/cards")
  end





end
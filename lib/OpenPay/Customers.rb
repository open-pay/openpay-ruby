require 'open_pay_resource'



class Customers < OpenPayResource


  #Bankaccount
  def create_bank_account(customer,bank_account)
    create(bank_account,"#{customer}/bankaccounts")
  end

  def get_bank_account(customer,bank_id)
    get("#{customer}/bankaccounts/#{bank_id}")
  end

  def all_bank_accounts(customer)
    get("#{customer}/bankaccounts/")

  end


  def each_bank_account(customer)
    get("#{customer}/bankaccounts/").each do |account|
       yield account
    end

  end



  def delete_bank_account(customer,bank_id)
    delete("#{customer}/bankaccounts/#{bank_id}")

  end





   #Customer
  def get_customer(customer_id)
    get(customer_id)
  end


  #Card
  def create_card(customer,card)
       create(card,"#{customer}/cards")
  end


  def get_card(customer,card_id)
    get("#{customer}/cards/#{card_id}")
  end


  def delete_card(customer,card_id)
      delete("#{customer}/cards/#{card_id}")
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
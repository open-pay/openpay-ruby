require 'open_pay_resource'



#TODO change name
class Bankaccounts < OpenPayResource




  def create(customer_id,bank_account)
    customers=@api_hook.create(:customers)
    customers.create_bank_account(customer_id,bank_account)
  end



  def get(customer_id='',bank_account=nil)
    customers=@api_hook.create(:customers)

    if bank_account
      customers.get_bank_account(customer_id,bank_account)
    else
      customers.get_bank_account(customer_id)
    end

  end


  def delete(customer_id='',bank_account=nil)
    customers=@api_hook.create(:customers)

    if bank_account
      customers.delete_bank_account(customer_id,bank_account)
    else
      customers.delete_bank_account(customer_id)
    end

  end


  def each(customer_id)
    customers=@api_hook.create(:customers)
     customers.each_bank_account(customer_id)  do |acc|
       yield acc
     end

  end







end

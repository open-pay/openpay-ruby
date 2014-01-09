require 'open_pay_resource'


class Bankaccounts < OpenPayResource


  def create(bank_account,customer_id)
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


  def delete(customer_id,bank_account)
    customers=@api_hook.create(:customers)
    customers.delete_bank_account(customer_id,bank_account)
  end


  def each(customer_id)
    customers=@api_hook.create(:customers)
     customers.each_bank_account(customer_id)  do |acc|
       yield acc
     end

  end


  def all(customer_id)
      customers=@api_hook.create(:customers)
      customers.all_bank_accounts(customer_id)
  end


  def delete_all(customer_id)

    if env == :production
      raise OpenpayException.new('This method is not supported on PRODUCTION',false)
    end

    customers=@api_hook.create(:customers)
    customers.delete_all_bank_accounts(customer_id)

  end



end

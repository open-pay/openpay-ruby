require 'open_pay_resource'

class  Transfers < OpenPayResource


  def create(transfer,customer_id)

      customers=@api_hook.create(:customers)
      customers.create_transfer(customer_id,transfer)

  end

  def all(customer_id)
    customers=@api_hook.create(:customers)
    customers.all_transfers(customer_id)
  end



  def get(transfer,customer_id)

    customers=@api_hook.create(:customers)
    customers.get_transfer(customer_id,transfer)

  end


  def each(customer_id)
    customers=@api_hook.create(:customers)
    customers.each_transfer(customer_id) do |tran|
      yield tran
    end

  end





end




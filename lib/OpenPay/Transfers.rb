require 'open_pay_resource'

class  Transfers < OpenPayResource


  def create(customer_id,transfer)
      customers=@api_hook.create(:customers)
      customers.create_transfer(customer_id,transfer)


   end
end




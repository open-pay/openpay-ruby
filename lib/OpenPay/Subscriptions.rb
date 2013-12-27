require 'open_pay_resource'

class Subscriptions  < OpenPayResource



  def create(subscription,plan_id)
    customers=@api_hook.create(:customers)
    customers.create_subscription(subscription,plan_id)
  end


def delete(subscription_id,customer_id)
  customers=@api_hook.create(:customers)
  customers.delete_subscription(customer_id, subscription_id)
end


  def get(subscription_id,customer_id)

    customers=@api_hook.create(:customers)
    customers.get_subscription(customer_id, subscription_id)

  end


  def all(customer_id)

    customers=@api_hook.create(:customers)
    customers.all_subscriptions(customer_id)

  end


  def each(customer_id)
    customers=@api_hook.create(:customers)
    customers.each_subscription(customer_id) do |c|
      yield c
    end
  end


  def delete_all(customer_id)
    customers=@api_hook.create(:customers)
    customers.delete_all_subscriptions(customer_id)

  end










end

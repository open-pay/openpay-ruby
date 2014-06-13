require 'open_pay_resource'

class Subscriptions < OpenPayResource

  def create(subscription, customer_id)
    customers=@api_hook.create(:customers)
    customers.create_subscription(subscription, customer_id)
  end

  def delete(subscription_id, customer_id)
    customers=@api_hook.create(:customers)
    customers.delete_subscription(customer_id, subscription_id)
  end

  def get(subscription_id, customer_id)
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

  def list(search_params,customer_id=nil)
    if customer_id
      customers=@api_hook.create(:customers)
      customers.list_subscriptions(customer_id,search_params)
    else
      super search_params
    end
  end

  def update(subscription_id,customer_id,params)
    customers=@api_hook.create(:customers)
    customers.update_subscription(subscription_id,customer_id,params)
  end

  def delete_all(customer_id)
    customers=@api_hook.create(:customers)
    customers.delete_all_subscriptions(customer_id)
  end
end

require 'open_pay_resource'

class Plans  < OpenPayResource

  def update(plan,plan_id)
    put(plan, "#{plan_id}")
  end

  def each_subscription(plan_id)
    get("#{plan_id}/subscriptions")
  end

  def all_subscriptions(plan_id)
    get("#{plan_id}/subscriptions")
  end

end

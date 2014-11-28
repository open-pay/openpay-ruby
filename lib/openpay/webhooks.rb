require 'open_pay_resource'

class Webhooks < OpenPayResource
  
  def verify(webhook_id, code)
   post('', "#{webhook_id}/verify/#{code}")
  end
  
end
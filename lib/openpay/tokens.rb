require 'open_pay_resource'

class Tokens < OpenPayResource
  def getPoints(token_id)
    get("#{token_id}/points")
  end
end
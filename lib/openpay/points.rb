require 'open_pay_resource'

class Points < OpenPayResource

   def getPointsBalance(token_id)
         tokens=@api_hook.create(:tokens)
         tokens.getPoints(token_id)
   end

end
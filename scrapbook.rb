$: << "lib/OpenPay/"
$: << "./lib/"
$: << "test"

require 'open_pay'
require 'Factories'
require 'pp'







include OpenPay

customer = FactoryGirl.build(:customer, name: "Ronnie")
card_hash = FactoryGirl.build(:valid_card)





merchant_id='mywvupjjs9xdnryxtplq'
private_key='sk_92b25d3baec149e6b428d81abfe37006'
#$public_key='pk_0b545e4507d74667a28a672c3b99d3a2'


opa=OpenPayApi.new(merchant_id, private_key)
customers=opa.create(:customers)
cards=opa.create(:cards)
cards.delete_all!


customer=customers.create(customer)


cards.create_card(card_hash)
#customers.add_card(customer['id'],card_hash)
customers.each_card(customer['id']) do |card|
   p card
end


#fees=opa.create(:fees)
 customers.each do |x|

  #p customers.get_customer(x['id'])
   #p customers.delete(x['id'])

   p customers.delete(x["id"])
 end



 #p set_collection("customers", customer)
#p res=get_collection("customers")
#p res=get_collection("charges")




require "OpenPay/version"
#File.join(File.dirname(__FILE__), '*.rb')





#   Ver documentacion complementaria en: http://www.openpay.mx
#
#   Uso:
#
#            #merchant_id  y private_key
#            merchant_id='mywvupjjs9xdnryxtplq'
#            private_key='sk_92b25d3baec149e6b428d81abfe37006'
#
#            #creamos factoria openpay
#             # en produccion
#             #openpay=OpenPayApi.new(merchant_id,private_key,true)
#            openpay=OpenPayApi.new(merchant_id,private_key)
 #
#            #creamos recursos especifico de openpay
#            bank_accounts=openpay.create(:bankaccounts)
#            customers=openpay.create(:customers)
#
#            #Creamos un Hash
#            customer_hash= FactoryGirl.build(:customer)
#
#            #Creamos un cliente usando el Hash anterior
#            customer=customers.create(customer_hash)
#
#            #Creamos una cuenta de banco para nuestro cliente
#            account_hash=FactoryGirl.build(:bank_account)
#            bank=bank_accounts.create(customer['id'],account_hash)
#
#             bank_account=bank_accounts.get(customer['id'],bank['id'])
#
#             expect(bank_account['alias']).to match 'Cuenta principal'
#
#              bank_accounts.delete(customer['id'],bank['id'])
module OpenPay

  require 'rest-client'
  require 'OpenPay/errors/open_pay_error'
  require  'bankaccounts'
  require  'cards'
  require  'charges'
  require  'customers'
  require  'fees'
  require 'payouts'
  require 'plans'
  require 'subscriptions'
  require 'transfers'
  require  'charges'
  require 'open_pay_api'
  require 'json'





end

require 'OpenPay/version'

require 'rest-client'
require 'json'

module Openpay

  #exceptions
 require 'openpay/errors/open_pay_api_exception_factory'

  require 'openpay/errors/open_pay_exception'
  require 'openpay/errors/openpay_api_transaction_error'
  require 'openpay/errors/openpay_api_connection_error'

  #base class
  require  'openpay/open_pay_resource'

  #resource classes
  require 'openpay/bankaccounts'
  require 'openpay/cards'
  require 'openpay/charges'
  require 'openpay/customers'
  require 'openpay/fees'
  require 'openpay/payouts'
  require 'openpay/plans'
  require 'openpay/subscriptions'
  require 'openpay/transfers'
  require 'openpay/charges'

  #api setup / constants
  require 'openpay/openpay_api'


end

#openpay version
require 'version'

#external dependencies
require 'rest-client'
require 'json'

module Openpay

  #api setup / constants
  require 'openpay_api'

  #base class
  require  'open_pay_resource'

  #resource classes
  require 'bankaccounts'
  require 'cards'
  require 'charges'
  require 'customers'
  require 'fees'
  require 'payouts'
  require 'plans'
  require 'subscriptions'
  require 'transfers'
  require 'charges'

  #exceptions
  require 'errors/openpay_exception_factory'
  require 'errors/openpay_exception'
  require 'errors/openpay_transaction_exception'
  require 'errors/openpay_connection_exception'

end
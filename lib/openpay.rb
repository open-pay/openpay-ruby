#openpay version
require 'version'

#external dependencies
require 'rest-client'
require 'json'

module Openpay

  #api setup / constants
  require_relative 'openpay/openpay_api'

  #base class
  require_relative  'openpay/open_pay_resource'

  #resource classes
  require_relative 'openpay/bankaccounts'
  require_relative 'openpay/cards'
  require_relative 'openpay/charges'
  require_relative 'openpay/customers'
  require_relative 'openpay/fees'
  require_relative 'openpay/payouts'
  require_relative 'openpay/plans'
  require_relative 'openpay/subscriptions'
  require_relative 'openpay/transfers'
  require_relative 'openpay/charges'

  #exceptions
  require_relative 'openpay/errors/openpay_exception_factory'
  require_relative 'openpay/errors/openpay_exception'
  require_relative 'openpay/errors/openpay_transaction_exception'
  require_relative 'openpay/errors/openpay_connection_exception'

end
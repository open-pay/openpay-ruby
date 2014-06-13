#openpay version
require 'version'

#external dependencies
require 'rest-client'
require 'json'

module Openpay

  #api setup / constants
  require 'openpay/openpay_api'

  #base class
  require 'openpay/open_pay_resource'

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

  #misc
  require 'openpay/utils/search_params'

  #exceptions
  require 'errors/openpay_exception_factory'
  require 'errors/openpay_exception'
  require 'errors/openpay_transaction_exception'
  require 'errors/openpay_connection_exception'

  include OpenpayUtils
end

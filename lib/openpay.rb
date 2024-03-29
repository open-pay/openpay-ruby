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
  require 'openpay/points'
  require 'openpay/tokens'
  require 'openpay/bankaccounts'
  require 'openpay/cards'
  require 'openpay/charges'
  require 'openpay/customers'
  require 'openpay/fees'
  require 'openpay/payouts'
  require 'openpay/plans'
  require 'openpay/subscriptions'
  require 'openpay/transfers'
  require 'openpay/webhooks'
  require 'openpay/colombia/customers_co'
  require 'openpay/colombia/charges_co'
  require 'openpay/colombia/cards_co'
  require 'openpay/colombia/plans_co'
  require 'openpay/colombia/subscriptions_co'
  require 'openpay/colombia/tokens_co'
  require 'openpay/colombia/webhooks_co'
  require 'openpay/colombia/pse_co'

  require 'openpay/peru/customers_pe'
  require 'openpay/peru/charges_pe'
  require 'openpay/peru/cards_pe'
  require 'openpay/peru/tokens_pe'
  require 'openpay/peru/checkouts_pe'
  require 'openpay/peru/webhooks_pe'

  #misc
  require 'openpay/utils/search_params'

  #exceptions
  require 'errors/openpay_exception_factory'
  require 'errors/openpay_exception'
  require 'errors/openpay_transaction_exception'
  require 'errors/openpay_connection_exception'

  include OpenpayUtils
end

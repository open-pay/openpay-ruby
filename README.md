<img src="http://www.openpay.mx/img/logo.png">

# Openpay-Ruby [![Build Status](https://travis-ci.org/open-pay/openpay-ruby.png?branch=master)](https://travis-ci.org/open-pay/openpay-ruby)

[![Gem Version](https://badge.fury.io/rb/openpay.svg)](http://badge.fury.io/rb/openpay)

##Description

ruby client for *Openpay api* services (version 1.0.8)

This is a ruby client implementing the payment services for *Openpay* at openpay.mx

For more information about Openpay visit:
 - http://openpay.mx/

For the full *Openpay api* documentation take a look at:
 - http://docs.openpay.mx/

## Installation

   Add the following line to your Gem file

    #openpay gem
     gem 'openpay'

Update your bundle:

    $ bundle

Or install it from the command line:

    $ gem install openpay

###Requirements

    * ruby 1.9 or higher

## Usage


### Initialization
```ruby
require 'openpay'


#merchant and private key
merchant_id='mywvupjjs9xdnryxtplq'
private_key='sk_92b25d3baec149e6b428d81abfe37006'


#An openpay resource factory instance is created out of the OpenpayApi
#it  points to the development environment  by default.
openpay=OpenpayApi.new(merchant_id,private_key)

#To enable production mode you should pass a third argument as true.
#openpay_prod=OpenpayApi.new(merchant_id,private_key,true)

#This ruby client manages a default timeout of 90 seconds to make the request 
#    to Openpay services, if you need to modify this value, you need to explicitly 
#    define the type of environment and followed by the new value for the timeout.
#Syntax:
#   openpay_prod=OpenpayApi.new(merchant_id,private_key,isProduction,timeout)
#Example:
#   openpay_prod=OpenpayApi.new(merchant_id,private_key,false,30)
 ```

The openpay factory instance is in charge to generate the required resources through a factory method (create).
Resource classes should be initialized using the factory method as described below.

 ```ruby
#creating an instance for each available resource
bankaccounts=openpay.create(:bankaccounts)
cards=openpay.create(:cards)
charges=openpay.create(:charges)
customers=openpay.create(:customers)
fees=openpay.create(:fees)
payouts=openpay.create(:payouts)
plans=openpay.create(:plans)
subscriptions=openpay.create(:subscriptions)
transfers=openpay.create(:transfers)
```

According to the current version of the *Openpay api* the available resources are:

- *bankaccounts*
- *cards*
- *charges*
- *customers*
- *fees*
- *payouts*
- *plans*
- *subscriptions*
- *transfers*

Each rest resource exposed in the rest *Openpay api* is represented by a class in this ruby API, being **OpenpayResource** the base class.


### Implementation
 Each resource depending of its structure and available methods, will have one or more of the methods described under the methods subsection.
 Below a short description about the implementation high level details. For detailed documentation take a look a the openpay api documentation.


#### Arguments
Given most resources belong, either to a merchant or a customer, the api was designed taking this in consideration, so:

The first argument represent the json/hash object, while the second argument which is optional represents the **customer_id**.
So if  just one argument is provided the action will be performed at the merchant level,
but if the second argument is provided passing the **customer_id**, the action will be performed at the customer level.


The following illustrates the api design.

 ```ruby
#Merchant
hash_out=open_pay_resource.create(hash_in)
json_out=open_pay_resource.create(json_in)


#Customer
hash_out=open_pay_resource.create(hash_in,customer_id)
json_out=open_pay_resource.create(json_in,customer_id)

 ```

####  Methods Inputs/Outputs

This api supports both ruby hashes and json strings as inputs and outputs. (See previous example)
If a ruby hash is passed in as in input, a hash will be returned as the method output.
if a json string is passed in as an input, a json string will be returned as the method function output.

This code excerpt from a specification demonstrates how you can use hashes and json strings  interchangeably.

Methods without inputs will return a ruby hash.

```ruby
it 'creates a fee using a json message' do
  #create new customer
  customer_hash= FactoryGirl.build(:customer)
  customer=@customers.create(customer_hash)

  #create customer card   , using factory girl to build the hash for us
  card_hash=FactoryGirl.build(:valid_card)
  card=@cards.create(card_hash, customer['id'])

  #create charge
  charge_hash=FactoryGirl.build(:card_charge, source_id: card['id'], order_id: card['id'], amount: 4000)
  charge=@charges.create(charge_hash, customer['id'])

  #create customer fee , using json as input, we get json as ouput
  fee_json =%^{"customer_id":"#{customer['id']}","amount":"12.50","description":"Cobro de Comisión"}^
  expect(@fees.create(fee_json)).to have_json_path('amount')
end
```

Here you can see how the **card_hash** representation looks like.

```ruby
require 'pp'
pp card_hash   =>

{:bank_name=>"visa",
:holder_name=>"Vicente Olmos",
:expiration_month=>"09",
:card_number=>"4111111111111111",
:expiration_year=>"14",
:bank_code=>"bmx",
:cvv2=>"111",
:address=>
{:postal_code=>"76190",
:state=>"QRO",
:line1=>"LINE1",
:line2=>"LINE2",
:line3=>"LINE3",
:country_code=>"MX",
:city=>"Queretaro"}}
```

Next, how we construct  the preceding hash using **FactoryGirl**.
**FactoryGirl** was used in our test suite to facilitate hash construction.
It  may help you  as well at your final implementation if you decide to use hashes.
(more examples at *test/Factories.rb*)

```ruby

FactoryGirl.define do
  factory :valid_card, class:Hash do
        bank_name  'visa'
        holder_name 'Vicente Olmos'
        expiration_month '09'
        card_number '4111111111111111'
        expiration_year '14'
        bank_code 'bmx'
        cvv2  '111'
       address {{
           postal_code: '76190',
           state: 'QRO',
           line1: 'LINE1',
           line2: 'LINE2',
           line3: 'LINE3',
           country_code: 'MX',
           city: 'Queretaro',
       }}
    initialize_with { attributes }
  end
```

###Methods design

This ruby API standardize the method names across all different resources using the **create**,**get**,**update** and **delete** verbs.

For full method documentation take a look at:
  - http://docs.openpay.mx/

The test suite at *test/spec* is a good source of reference.

#####create

   Creates the given resource
 ```ruby
     open_pay_resource.create(representation,customer_id=nil)
 ```

#####get

   Gets an instance of a  given resource

```ruby
open_pay_resource.get(object_id,customer_id=nil)
```

#####update

   Updates an instance of a given resource

```ruby
open_pay_resource.update(representation,customer_id=nil)
```

#####delete

  Deletes an instance of the given resource

```ruby
open_pay_resource.delete(object_id,customer_id=nil)
```

#####all
   Returns an array of all instances of a resource
```ruby
open_pay_resource.all(customer_id=nil)
```

#####each
   Returns a block for each instance resource
```ruby
open_pay_resource.each(customer_id=nil)
 ```

#####delete_all(available only under the development environment)

   Deletes all instances of the given resource

```ruby
#in case this method is executed under the production environment an OpenpayException will be raised.
open_pay_resource.delete_all(customer_id=nil)
```


###API Methods


#### bank_accounts

- creates a merchant bank account , is not supported through the API, use the console instead.

- creates  a customer bank account

        bank_accounts.create(account_hash,customer_id)

- get a given bank account for a given customer

         bank_account=bank_accounts.get(customer_id,bankaccount_id)

- each customer bank account

        bank_accounts.each(customer_id) do |bank_account|
            bank_account['alias']
        end

- list merchant / customer bank accounts

        search_params = OpenpayUtils::SearchParams.new
        search_params.limit = 1

        merchant_filtered_list = bank_accounts.list(search_params)
        customer_filtered_list = bank_accounts.list(search_params, customer_id)

- all bank accounts for a given customer

        accounts=bank_accounts.all(customer_id)

- deletes a given customer bank account

         bank_accounts.delete(customer_id,bank_id)

- deletes all customer bank accounts (sandbox mode only)

         bank_accounts.delete_all(customer['id'])

#### cards

- creates a merchant card

        cards.create(card_json)

- creates a customer card

        cards.create(card_hash, customer_id)

- gets merchant card

        card=cards.get(card_id)

- gets customer card

         card=cards.get(card_id, customer_id)

- each merchant card

        cards.each {|merchant_card| p card}

- list merchant / customer cards

        search_params = OpenpayUtils::SearchParams.new
        search_params.limit = 1

        merchant_filtered_list = cards.list(search_params)
        customer_filtered_list = cards.list(search_params, customer_id)

- each customer card

        cards.each(customer_id)   {|customer_card | p customer_card }

- all merchant cards

        merchant_cards=cards.all

- all customer cards

        customer_cards=cards.all(customer_id)

- delete merchant card

        cards.delete(card_id)

- delete customer card

        cards.delete(card_id,customer_id)

- delete all merchant cards

        cards.delete_all

- delete all customer cards

        cards.delete_all(customer_id)


#### charges


 - creates merchant charge

        charges.create(charge_hash)

 - creates customer charge

        charges.create(charge_hash,customer_id)

- gets merchant charge

        merchant_charge=charges.get(charge_id)

- gets  customer charge

        customer_charge=charges.get(charge_id,customer_id)

- each merchant charge

        charges.each {|charge| p charge}

- list merchant / customer charges

        search_params = OpenpayUtils::SearchParams.new
        search_params.limit = 1

        merchant_filtered_list = charges.list(search_params)
        customer_filtered_list = charges.list(search_params, customer_id)

- each customer charge

        charges.each(customer_id) {|charge| p charge}


- all merchant charge

        charges.all

- all customer charge

        charges.all(customer_id)

- capture merchant card

        charges.capture(charge_id)

- capture customer card

        charges.capture(charge['id'],customer['id'])

- confirm capture merchant

        #pass a hash with the following options, no customer_id needed
        confirm_capture_options = { transaction_id: transaction['id'], amount: 100  }
        charges.confirm_capture(confirm_capture_options)

- confirm capture customer

        #pass a hash with the following options, pass the customer_id
        confirm_capture_options = { customer_id: customer['id'], transaction_id: charge['id'], amount: 100  }
        charges.confirm_capture(confirm_capture_options)

- refund  merchant charge

        charges.refund(charge_id, refund_description_hash)

- refund  merchant charge

        charges.refund(charge_id, refund_description_hash)


#### customers

- creates customer

        customers.create(customer_json)

- get customer

        customer=customers.get(customer_id)

- update customer

        customers.update(customer_hash)

- delete customer

        customers.delete(customer_id)

- each customer

        customers.each do {|customer|  p customer }

- list customers

        search_params = OpenpayUtils::SearchParams.new
        search_params.limit = 1

        customers_filtered_list = customers.list(search_params)


- all customer

        all_customers=customers.all

- delete all customers (sand box mode only)

         all_customers=customers.all

#### fees

- creates fee

        #In order to create a fee a charge should exists
        fee.create(fee_hash)

- gets all fees

        all_fees=fees.all

- list customer fees

        search_params = OpenpayUtils::SearchParams.new
        search_params.limit = 1

        merchant_filtered_list = fees.list(search_params)

#### payouts

- creates a merchant payout

        payouts.create(payout_json)

- creates a customer payout

        payouts.create(payout_hash,customer_id)

- gets a merchant payout

        payouts.get(payout_id)
- gets a customer payout

        payouts.get(payout_id,customer_id)

- all merchant payouts

        merchant_payouts=payouts.all

- all customer payouts

        customer_payouts=payouts.all(customer_id)

- each merchant payout

        payouts.each { |payout| p payout }

- each customer payout

        payouts.each(customer_id) { |payout| p payout }

- list merchant/customer payouts

        search_params = OpenpayUtils::SearchParams.new
        search_params.limit = 1

        merchant_filtered_list = payouts.list(search_params)
        customer_filtered_list = payouts.list(search_params, customer_id)

#### plans

- create merchant plan

        plans.create(plan_hash)


- create  customer plan

        plans.create(plan_hash,customer_id)

- get a merchant plan

        merchant_plan=plans.get(plan_id)

- get a customer plan

        customer_plan=plans.get(plan_id,customer_id)


- updates a merchant plan

         plans.update(plan_hash,customer_id)

- updates a customer plan

        plans.update(plan_hash,customer_id)

- each merchant plan

        plans.each do {|plan| p plan }

- each customer plans

        plans.each(customer_id)  do {|plan| p plan }


- list merchant /customer plan

        search_params = OpenpayUtils::SearchParams.new
        search_params.limit = 1

        merchant_filtered_list = plans.list(search_params)
        customer_filtered_list = plans.list(search_params, customer_id)


- all merchant plans

        plans.all

- all customer plans

        plans.all(customer_id)


#### subscriptions

- create customer subscriptions

        subscriptions.create(subscriptions_hash,customer_id)

- get customer subscription

        subscriptions.get(subscriptions_hash,customer_id)

- update customer subscription

        subscription_update_hash={ trial_end_date: "2016-01-12" }
        subscriptions.update(subscription_id,customer_id, subscription_update_hash )

- all customer subscription

        subscriptions.all(customer_id)


- each customer subscription

        subscriptions.each(customer_id)    {|subscription| p subscription }


- list customer subscriptions

        search_params = OpenpayUtils::SearchParams.new
        search_params.limit = 1

        customer_filtered_list = subscriptions.list(search_params, customer_id)

- deletes customer subscription

         subscriptions.delete(customer_id)

- deletes all customer subscriptions ( sandbox mode only)

         subscriptions.delete(customer_id)


#### transfers

- create transfer

        transfers.create(transfer_hash,customer_id)


- get  transfer

        transfers.get(transfer_id,customer_id)

- all customer transfers

        transfers.all(customer_id)


- each customer transfer

        transfers.each(customer_id)    {|transfer| p transfer }

- list customer transfers

        search_params = OpenpayUtils::SearchParams.new
        search_params.limit = 1

        customer_filtered_list = transfers.list(search_params, customer_id)


#### Exceptions

This API generates 3 different Exception classes.

-  **OpenpayException**: Generic base API exception class, Generic API exceptions.

     - Internal server error (500 Internal Server Error).
     - OpenpayApi factory method, invalid resource name.

    Examples:

 ```ruby
  #production mode
  openpay_prod=OpenpayApi.new(@merchant_id,@private_key,true)
  customers=openpay_prod.create(:customers)
  customers.delete_all # will raise an OpenpayException
 ```

  ```ruby
   #production mode
   openpay_prod=OpenpayApi.new(@merchant_id,@private_key,true)
   customers=openpay_prod.create(:non_existing_resource)    # will raise an OpenpayException
  ```

-  **OpenpayConnectionException**: Exception class for connection related issues, errors happening prior  the server connection.

     - Authentication Error (401 Unauthorized)
     - Connection Errors.
     - SSL Errors.

    Example:
     ```ruby
     #invalid id and key
     merchant_id='santa'
     private_key='invalid'

     openpay=OpenpayApi.new(merchant_id, private_key)
     customers=openpay.create(:customers)

      begin
         customers.get('23444422211')
      rescue OpenpayConnectionException => e
         e.http_code  #  => 401
         e.error_code # => 1002
         e.description# => 'The api key or merchant id are invalid.'
         e.json_body #  {"category":"request","description":"The api key or merchant id are invalid.","http_code":401,"error_code":1002,"request_id":null}
       end
     ```

- **OpenpayTransactionException**: Errors happening after the initial connection has been initiated, errors during transactions.

   - Bad Request (e.g. Malformed json,Invalid data)
   - Unprocessable Entity (e.g. invalid data)
   - Resource not found (404 Not Found)
   - Conflict (e.g. resource already exists)
   - PaymentRequired (e.g. insufficient funds)
   - UnprocessableEntity ( e.g. stolen card )

 *Bad Request* Example:

```ruby
email='foo'
customer_hash = FactoryGirl.build(:customer, email: email)
begin
    customers.create(customer_hash)
rescue OpenpayTransactionException => e
    e.http_code# => 400
    e.error_code# => 1001
    e.description# => 'email\' not a well-formed email address'
end
  ```

  *Resource not found* Example:

```ruby
begin
  #non existing customer
  customers.delete('1111')
rescue OpenpayApiTransactionError => e
  e.http_code# => 404
  e.error_code# =>1005
  e.description# =>"The customer with id '1111' does not exist"
end
```

###These exceptions have the following attributes:

- *category*
- *description*
- *http_code*
- *error_code*
- *json_message*

For more information about categories, descriptions and codes take a look at:
- http://docs.openpay.mx/#errores
- http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html


##Debug

In the Openpay dashboard you are able to see every request and its corresponding request/response.
    - https://sandbox-dashboard.openpay.mx

##Developer Notes

- bank accounts for merchant cannot be created using the api. It should be done through the dashboard.
- Is recommended to reset your account using the dashboard when running serious testing (assure clean state)
- check openpay_api.rb for Logger configuration
- travis  https://travis-ci.org/open-pay/openpay-ruby , if a test fails it will leave leave some records, it may affect posterior tests.
   it is recommended to reset the console/account to assure a clean state after a failure occurs.

## More information
For more use cases take a look at the *test/spec* folder

  1.  http://docs.openpay.mx/















































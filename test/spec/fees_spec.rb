require '../spec_helper'

describe Fees do


  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'

    @openpay=OpenpayApi.new(@merchant_id, @private_key)
    @customers=@openpay.create(:customers)
    @cards=@openpay.create(:cards)
    @charges=@openpay.create(:charges)

    @bank_accounts=@openpay.create(:bankaccounts)

    @fees=@openpay.create(:fees)

  end


  after(:all) do
    @bank_accounts.delete_all
    @customers.delete_all
  end


  describe '.create' do

    #In order to create a fee a charge should exists

    it 'creates a fee  ' do
      #create new customer
      customer_hash= FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)

      #create customer card
      card_hash=FactoryGirl.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #create charge
      charge_hash=FactoryGirl.build(:card_charge, source_id: card['id'], order_id: card['id'], amount: 4000)
      charge=@charges.create(charge_hash, customer['id'])

      #create customer fee
      fee_hash = FactoryGirl.build(:fee, customer_id: customer['id'])


      @fees.create(fee_hash)

      #cleanup
      @cards.delete(card['id'], customer['id'])
      @customers.delete(customer['id'])

    end


    it 'creates a fee using a json message' do
      #create new customer
      customer_hash= FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)

      #create customer card
      card_hash=FactoryGirl.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #create charge
      charge_hash=FactoryGirl.build(:card_charge, source_id: card['id'], order_id: card['id'], amount: 4000)
      charge=@charges.create(charge_hash, customer['id'])

      #create customer fee
      fee_json =%^{"customer_id":"#{customer['id']}","amount":"12.50","description":"Cobro de Comisión"}^
      expect(@fees.create(fee_json)).to have_json_path('amount')

    end

  end

  describe '.all' do

    it 'get all fees' do

      #create new customer
      customer_hash= FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)

      #create customer card
      card_hash=FactoryGirl.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #create charge
      charge_hash=FactoryGirl.build(:card_charge, source_id: card['id'], order_id: card['id'], amount: 4000)
      charge=@charges.create(charge_hash, customer['id'])


      #create customer fee
      fee_hash = FactoryGirl.build(:fee, customer_id: customer['id'])
      @fees.create(fee_hash)
      expect(@fees.all.first['customer_id']).to match customer['id']


      #cleanup
      @cards.delete(card['id'], customer['id'])
      @customers.delete(customer['id'])


    end
  end
end





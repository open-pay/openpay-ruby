require_relative '../spec_helper'

describe Fees do

  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'
    
    #LOG.level=Logger::DEBUG

    @openpay=OpenpayApi.new(@merchant_id, @private_key)
    @customers=@openpay.create(:customers)
    @cards=@openpay.create(:cards)
    @charges=@openpay.create(:charges)

    @bank_accounts=@openpay.create(:bankaccounts)

    @fees=@openpay.create(:fees)

  end

  after(:all) do
    @customers.delete_all
  end

  it 'has all required methods' do
    %w(all each create get list delete).each do |meth|
      expect(@customers).to respond_to(meth)
    end
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
      @charges.create(charge_hash, customer['id'])

      #create customer fee
      fee_hash = FactoryGirl.build(:fee, customer_id: customer['id'])
      @fees.create(fee_hash)

      #performs check
      expect(@fees.all.first['customer_id']).to match customer['id']

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
      @charges.create(charge_hash, customer['id'])

      #create customer fee using json
      fee_json =%^{"customer_id":"#{customer['id']}","amount":"12.50","description":"Cobro de Comision"}^
      #performs check , it returns json
      expect(@fees.create(fee_json)).to have_json_path('amount')

    end

  end

  describe '.each' do

    it 'iterates over all elements' do
      @fees.each do |fee|
        expect(fee['description']).to match /\s+/
      end
    end

  end

  describe '.list' do

    it 'list fees with a given filter' do

      #create new customer
      customer_hash= FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)

      #create customer card
      card_hash=FactoryGirl.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #create charge
      charge_hash=FactoryGirl.build(:card_charge, source_id: card['id'], order_id: card['id'], amount: 4000)
      @charges.create(charge_hash, customer['id'])

      #create customer fee
      fee_hash = FactoryGirl.build(:fee, customer_id: customer['id'])
      @fees.create(fee_hash)

      #create customer fee
      fee_hash = FactoryGirl.build(:fee, customer_id: customer['id'])
      @fees.create(fee_hash)


      #performs check
      search_params = OpenpayUtils::SearchParams.new
      search_params.limit = 1
      expect(@fees.list(search_params).size).to eq 1


      #cleanup
      @cards.delete(card['id'], customer['id'])
      @customers.delete(customer['id'])

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
      @charges.create(charge_hash, customer['id'])

      #create customer fee
      fee_hash = FactoryGirl.build(:fee, customer_id: customer['id'])
      @fees.create(fee_hash)

      #performs check
      expect(@fees.all.first['amount']).to be_a Float

      #cleanup
      @cards.delete(card['id'], customer['id'])
      @customers.delete(customer['id'])

    end
  end
end

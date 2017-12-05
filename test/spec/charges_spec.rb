require_relative '../spec_helper'

describe Charges do

  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'

    @openpay=OpenpayApi.new(@merchant_id,@private_key)
    @customers=@openpay.create(:customers)
    
    #LOG.level=Logger::DEBUG

    @charges=@openpay.create(:charges)
    @cards=@openpay.create(:cards)
    @bank_accounts=@openpay.create(:bankaccounts)

    @cards.delete_all

  end

  it 'has all required methods' do
    %w(all each create get list delete).each do |meth|
      expect(@charges).to respond_to(meth)
    end
  end
  
  describe '.create' do

    it 'creates a new merchant charge using the card method using a pre-stored card' do

      #create card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash)

      #create charge attached to prev created card
      charge_hash=FactoryBot.build(:card_charge, source_id: card['id'], order_id: card['id'],amount: 101)
      charge=@charges.create(charge_hash)

      #perform check
      stored_charge=@charges.get(charge['id'])
      expect(stored_charge['amount']).to be_within(0.1).of(101)

      #clean up
      @cards.delete(card['id'])

    end

    it 'creates a new customer charge using the card method using a pre-stored card' do

      #create new customer
      customer_hash= FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #create customer card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash,customer['id'])

      #create charge
      charge_hash=FactoryBot.build(:card_charge, source_id:card['id'],order_id: card['id'])
      charge=@charges.create(charge_hash,customer['id'])

      #perform check
      stored_charge=@charges.get(charge['id'],customer['id'])
      expect(stored_charge['amount']).to be_within(0.1).of(1000)

      #clean up
      @cards.delete(card['id'],customer['id'])
      @customers.delete(customer['id'])

    end

  end

  describe '.get' do

    it 'gets a merchant charge'  do

      #create card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash)

      #create charge attached to prev created card
      charge_hash=FactoryBot.build(:card_charge, source_id: card['id'], order_id: card['id'],amount: 505)
      charge=@charges.create(charge_hash)

      #perform check
      stored_charge=@charges.get(charge['id'])
      expect(stored_charge['amount']).to be_within(0.1).of(505)

      #clean up
      @cards.delete(card['id'])

    end

    it 'gets a customer charge' do

      #create new customer
      customer_hash= FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #create customer card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash,customer['id'])

      #create charge
      charge_hash=FactoryBot.build(:card_charge, source_id:card['id'],order_id: card['id'],amount: 4000)
      charge=@charges.create(charge_hash,customer['id'])

      #perform check
      stored_charge=@charges.get(charge['id'],customer['id'])
      expect(stored_charge['amount']).to be_within(0.5).of(4000)

      #clean up
      @cards.delete(card['id'],customer['id'])
      @customers.delete(customer['id'])

    end

  end

  describe '.all' do

    it 'all merchant charges' do
      #TODO test can be improved,  but since charges cannot be deleted it make this difficult
      expect(@charges.all.size).to be_a Integer
   end

    it 'all customer charges' do
      #create new customer
      customer_hash= FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      expect(@charges.all(customer['id']).size).to be 0
      @customers.delete(customer['id'])

    end

  end

  describe '.capture' do

    it 'captures a merchant card charge'  do

      #create new customer
      customer_hash= FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #create merchant card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash)

      #create merchant charge
      charge_hash=FactoryBot.build(:card_charge, source_id:card['id'],order_id: card['id'],amount: 4000, capture:'false')
      charge=@charges.create(charge_hash)

      #capture merchant charge
      @charges.capture(charge['id'])

      #clean up
      @cards.delete(card['id'])
      @customers.delete(customer['id'])

    end

    it 'captures a customer card charge' do
      #create new customer
      customer_hash= FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #create customer card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash,customer['id'])

      #create charge
      charge_hash=FactoryBot.build(:card_charge, source_id:card['id'],order_id: card['id'],amount: 4000,capture:'false')
      charge=@charges.create(charge_hash,customer['id'])

      #capture customer charge
      @charges.capture(charge['id'],customer['id'])


      #clean up
      @cards.delete(card['id'],customer['id'])
      @customers.delete(customer['id'])
    end

  end

  describe '.confirm_capture' do

    it 'confirms a capture on a merchant charge' do

      #create new customer
      customer_hash= FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #create merchant card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash)

      #create merchant charge
      charge_hash=FactoryBot.build(:card_charge, source_id:card['id'],order_id: card['id'],amount: 4000, capture:'false')
      charge=@charges.create(charge_hash)

      confirm_capture_options = {  transaction_id: charge['id'], amount: 100  }

      #confirm capture
      res = @charges.confirm_capture(confirm_capture_options)
      expect(res['amount']).to eq 100

      #clean up
      @cards.delete(card['id'])
      @customers.delete(customer['id'])

    end

    it 'confirms a capture on a customer charge' do

      customer_hash= FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #create customer card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash,customer['id'])

      #create charge
      charge_hash=FactoryBot.build(:card_charge, source_id:card['id'],order_id: card['id'],amount: 4000,capture:'false')
      charge=@charges.create(charge_hash,customer['id'])

      confirm_capture_options = { customer_id: customer['id'], transaction_id: charge['id'], amount: 100  }

      #confirm capture
      res = @charges.confirm_capture(confirm_capture_options)
      expect(res['amount']).to eq 100

      #clean up
      @cards.delete(card['id'],customer['id'])
      @customers.delete(customer['id'])

    end

  end

  describe '.refund' do

    #Refunds apply only for card charges
    it 'refunds  an existing merchant charge' do
      #create card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash)

      #create charge attached to prev created card
      charge_hash=FactoryBot.build(:card_charge, source_id: card['id'], order_id: card['id'],amount: 505)
      charge=@charges.create(charge_hash)

      #creates refund_description
      refund_description=FactoryBot.build(:refund_description)
      expect(@charges.get(charge['id'])['refund']).to be nil

      @charges.refund(charge['id'],refund_description)
      expect(@charges.get(charge['id'])['refund']['amount'] ).to be_within(0.1).of(505)

      #clean up
      @cards.delete(card['id'])

    end
    
    it 'refunds an existing customer charge' do
      #create new customer
      customer_hash= FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #create customer card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash,customer['id'])

      #create charge
      charge_hash=FactoryBot.build(:card_charge, source_id:card['id'],order_id: card['id'],amount: 100)
      charge=@charges.create(charge_hash,customer['id'])

      #creates refund_description
      refund_description=FactoryBot.build(:refund_description)

      #perform check
      expect(@charges.get(charge['id'],customer['id'])['refund']).to be nil
      sleep(50)
      @charges.refund(charge['id'],refund_description,customer['id'])
      
      expect(@charges.get(charge['id'],customer['id'])['refund']['amount'] ).to be_within(0.1).of(100)

      #clean up
      @cards.delete(card['id'],customer['id'])
      @customers.delete(customer['id'])

    end
    
  end

  describe '.list' do

    it 'list customer charges' do

      #create new customer
      customer_hash= FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #create customer card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash,customer['id'])

      #create charge
      charge_hash=FactoryBot.build(:card_charge, source_id:card['id'],order_id: card['id'])
      charge=@charges.create(charge_hash,customer['id'])
      charge_hash=FactoryBot.build(:card_charge, source_id:card['id'],order_id: card['id']+"1")
      charge2=@charges.create(charge_hash,customer['id'])

      #perform check
      search_params = OpenpayUtils::SearchParams.new
      search_params.limit = 1
      expect(@charges.all(customer['id']).size).to eq 2
      expect(@charges.list(search_params,customer['id']).size).to eq 1

      #clean up
      @cards.delete(card['id'],customer['id'])
      @customers.delete(customer['id'])

    end

  end

  describe '.each' do

    it 'iterates over merchant charges' do
      @charges.each do |charge|
        #perform check.
        expect(charge['amount']).to be_a Float
      end
    end

    it 'iterate over customer charges' do

      #create new customer
      customer_hash= FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #create customer card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash,customer['id'])

      #create charge
      charge_hash=FactoryBot.build(:card_charge, source_id:card['id'],order_id: card['id'],amount: 4)
      @charges.create(charge_hash,customer['id'])
      charge2_hash=FactoryBot.build(:card_charge, source_id:card['id'],order_id: card['id'+"2"],amount: 4)

      @charges.create(charge2_hash,customer['id'])

      @charges.each(customer['id']) do |charge|
        expect(charge['operation_type']).to match 'in'
        expect(charge['amount']).to be_within(0.1).of(4)
      end

      #cleanup
      @cards.delete(card['id'],customer['id'])
      @customers.delete(customer['id'])

    end

  end

end

require_relative '../../spec_helper'

describe Charges do

  before(:all) do
    @merchant_id = 'mwf7x79goz7afkdbuyqd'
    @private_key = 'sk_94a89308b4d7469cbda762c4b392152a'
    @openpay = OpenpayApi.new(@merchant_id, @private_key, "co")
    @customers = @openpay.create(:customers)
    #LOG.level=Logger::DEBUG
    @charges = @openpay.create(:charges)
    @cards = @openpay.create(:cards)

  end

  it 'has all required methods' do
    %w(all each create get list delete).each do |meth|
      expect(@charges).to respond_to(meth)
    end
  end

  describe '.create' do

    it 'creates a new merchant charge using the card method using a pre-stored card' do
      #create card
      card_hash = FactoryBot.build(:valid_card_col)
      card = @cards.create(card_hash)
      #create charge attached to prev created card
      charge_hash = FactoryBot.build(:card_charge_col, source_id: card['id'], order_id: card['id'], amount: 101)
      charge = @charges.create(charge_hash)
      #perform check
      stored_charge = @charges.get(charge['id'])
      expect(stored_charge['amount']).to be_within(0.1).of(101)
      #clean up
      @cards.delete(card['id'])
    end

    it 'creates a new customer charge using the card method using a pre-stored card' do
      #create new customer
      customer_hash = FactoryBot.build(:customer_col)
      customer = @customers.create(customer_hash)
      #create customer card
      card_hash = FactoryBot.build(:valid_card_col)
      card = @cards.create(card_hash, customer['id'])
      #create charge
      charge_hash = FactoryBot.build(:card_charge_col_2, source_id: card['id'], order_id: card['id'])
      charge = @charges.create(charge_hash, customer['id'])
      #perform check
      stored_charge = @charges.get(charge['id'], customer['id'])
      expect(stored_charge['amount']).to be_within(0.1).of(1000)
      #clean up
      @cards.delete(card['id'], customer['id'])
      #no se puede borrar usuario por transacciones asociadas
      # @customers.delete(customer['id'])
    end

    it 'creates a new merchant charge using the card method using a pre-stored card STORE' do
      #create card
      card_hash = FactoryBot.build(:valid_card_col)
      card = @cards.create(card_hash)
      #create charge attached to prev created card
      charge_hash = FactoryBot.build(:card_charge_store_col, order_id: card['id'], amount: 101)
      charge = @charges.create(charge_hash)
      #perform check
      stored_charge = @charges.get(charge['id'])
      paymentMethod = stored_charge['payment_method']
      expect(paymentMethod['type']).to eq('store')
      #clean up
      @cards.delete(card['id'])
    end

    it 'creates a new customer charge using the card method using a pre-stored card STORE' do
      #create new customer
      customer_hash = FactoryBot.build(:customer_col)
      customer = @customers.create(customer_hash)
      #create customer card
      card_hash = FactoryBot.build(:valid_card_col)
      card = @cards.create(card_hash, customer['id'])
      #create charge
      charge_hash = FactoryBot.build(:card_charge_store_col_2, method: 'store', order_id: card['id'])
      charge = @charges.create(charge_hash, customer['id'])
      #perform check
      stored_charge = @charges.get(charge['id'], customer['id'])
      paymentMethod = stored_charge['payment_method']
      expect(paymentMethod['type']).to eq('store')
      #clean up
      @cards.delete(card['id'], customer['id'])
      #no se puede borrar usuario por transacciones asociadas
      # @customers.delete(customer['id'])
    end

  end

  describe '.get' do

    it 'gets a merchant charge' do
      #create card
      card_hash = FactoryBot.build(:valid_card_col)
      card = @cards.create(card_hash)
      #create charge attached to prev created card
      charge_hash = FactoryBot.build(:card_charge_col, source_id: card['id'], order_id: card['id'], amount: 505)
      charge = @charges.create(charge_hash)
      #perform check
      stored_charge = @charges.get(charge['id'])
      expect(stored_charge['amount']).to be_within(0.1).of(505)
      #clean up
      @cards.delete(card['id'])

    end

    it 'gets a customer charge' do
      #create new customer
      customer_hash = FactoryBot.build(:customer_col)
      customer = @customers.create(customer_hash)
      #create customer card
      card_hash = FactoryBot.build(:valid_card_col)
      card = @cards.create(card_hash, customer['id'])
      #create charge
      charge_hash = FactoryBot.build(:card_charge_col_2, source_id: card['id'], order_id: card['id'], amount: 4000)
      charge = @charges.create(charge_hash, customer['id'])
      #perform check
      stored_charge = @charges.get(charge['id'], customer['id'])
      expect(stored_charge['amount']).to be_within(0.5).of(4000)
      #clean up
      @cards.delete(card['id'], customer['id'])
      # no se puede borrar usuario por transacciones asociadas
      # @customers.delete(customer['id'])

    end

  end

  describe '.all' do

    it 'all merchant charges' do
      #TODO test can be improved,  but since charges cannot be deleted it make this difficult
      expect(@charges.all.size).to be_a Integer
    end

    it 'all customer charges' do
      #create new customer
      customer_hash = FactoryBot.build(:customer_col)
      customer = @customers.create(customer_hash)
      expect(@charges.all(customer['id']).size).to be 0
      @customers.delete(customer['id'])

    end

  end

  describe '.refund' do
    #Refunds apply only for card charges
    it 'refunds  an existing merchant charge' do
      #create card
      card_hash = FactoryBot.build(:valid_card_col)
      card = @cards.create(card_hash)
      #create charge attached to prev created card
      charge_hash = FactoryBot.build(:card_charge_col, source_id: card['id'], order_id: card['id'], amount: 505)
      charge = @charges.create(charge_hash)
      #creates refund_description
      refund_description = FactoryBot.build(:refund_description)
      expect(@charges.get(charge['id'])['refund']).to be nil
      @charges.refund(charge['id'], refund_description)
      expect(@charges.get(charge['id'])['refund']['amount']).to be_within(0.1).of(505)
      #clean up
      @cards.delete(card['id'])
    end

    it 'refunds an existing customer charge' do
      #create new customer
      customer_hash = FactoryBot.build(:customer_col)
      customer = @customers.create(customer_hash)
      #create customer card
      card_hash = FactoryBot.build(:valid_card_col)
      card = @cards.create(card_hash, customer['id'])
      #create charge
      charge_hash = FactoryBot.build(:card_charge_col_2, source_id: card['id'], order_id: card['id'], amount: 100)
      charge = @charges.create(charge_hash, customer['id'])
      #creates refund_description
      refund_description = FactoryBot.build(:refund_description)
      #perform check
      expect(@charges.get(charge['id'], customer['id'])['refund']).to be nil
      sleep(50)
      @charges.refund(charge['id'], refund_description, customer['id'])
      expect(@charges.get(charge['id'], customer['id'])['refund']['amount']).to be_within(0.1).of(100)
      #clean up
      @cards.delete(card['id'], customer['id'])
      # No se puede borrar usuario por transacciones asociadas
      # @customers.delete(customer['id'])
    end

  end

  describe '.list' do

    it 'list customer charges' do

      #create new customer
      customer_hash = FactoryBot.build(:customer_col)
      customer = @customers.create(customer_hash)
      #create customer card
      card_hash = FactoryBot.build(:valid_card)
      card = @cards.create(card_hash, customer['id'])
      #create charge
      charge_hash = FactoryBot.build(:card_charge, source_id: card['id'], order_id: card['id'])
      charge = @charges.create(charge_hash, customer['id'])
      charge_hash = FactoryBot.build(:card_charge, source_id: card['id'], order_id: card['id'] + "1")
      charge2 = @charges.create(charge_hash, customer['id'])
      #perform check
      search_params = OpenpayUtils::SearchParams.new
      search_params.limit = 1
      search_params.creation_gte = '2000-01-01'
      search_params.amount_gte = 1
      expect(@charges.all(customer['id']).size).to eq 2
      expect(@charges.list(search_params, customer['id']).size).to eq 1
      #clean up
      @cards.delete(card['id'], customer['id'])

      # No se puede borrar usuario por transacciones asociadas
      # @customers.delete(customer['id'])

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
      customer_hash = FactoryBot.build(:customer_col)
      customer = @customers.create(customer_hash)
      #create customer card
      card_hash = FactoryBot.build(:valid_card_col)
      card = @cards.create(card_hash, customer['id'])
      #create charge
      charge_hash = FactoryBot.build(:card_charge_col_2, source_id: card['id'], order_id: card['id'], amount: 4)
      @charges.create(charge_hash, customer['id'])
      charge2_hash = FactoryBot.build(:card_charge_col_2, source_id: card['id'], order_id: card['id' + "2"], amount: 4)
      @charges.create(charge2_hash, customer['id'])
      @charges.each(customer['id']) do |charge|
        expect(charge['operation_type']).to match 'in'
        expect(charge['amount']).to be_within(0.1).of(4)
      end

      #cleanup
      @cards.delete(card['id'], customer['id'])
      # No se puede borrar usuario por transacciones asociadas
      # @customers.delete(customer['id'])
    end

  end

end

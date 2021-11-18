require_relative '../../spec_helper'

describe ChargesPe do

  before(:all) do
    @merchant_id = 'm3cji4ughukthjcsglv0'
    @private_key = 'sk_f934dfe51645483e82106301d985a4f6'
    @openpay = OpenpayApi.new(@merchant_id, @private_key, "pe")
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

    it 'create charge to customer' do
      #create new customer
      card_hash = FactoryBot.build(:valid_card_peru, holder_name: 'Pepe')
      customers = @openpay.create(:customers)
      customer_hash = FactoryBot.build(:customer_pe)
      customer = customers.create(customer_hash)
      #creates a customer card
      card = @cards.create(card_hash, customer['id'])
      charge_hash = FactoryBot.build(:charge_pe, source_id: card['id'], amount: 101)
      charge = @charges.create(charge_hash, customer['id'])
      expect(charge['amount']).to be_within(0.1).of(101)
    end

    it 'create charge to merchant' do
      card_hash = FactoryBot.build(:valid_card_peru)
      card = @cards.create(card_hash)
      #create charge attached to prev created card
      charge_hash = FactoryBot.build(:charge_merchant_pe, source_id: card['id'], amount: 101)
      charge = @charges.create(charge_hash)
      #perform check
      stored_charge = @charges.get(charge['id'])
      expect(stored_charge['amount']).to be_within(0.1).of(101)
      #clean up
      @cards.delete(card['id'])
    end

    it 'create redirect charge to customer' do
      #create new customer
      customers = @openpay.create(:customers)
      customer_hash = FactoryBot.build(:customer_pe)
      customer = customers.create(customer_hash)
      #creates a customer card
      charge_hash = FactoryBot.build(:charge_redirect_customer_peru, amount: 101)
      charge = @charges.create(charge_hash, customer['id'])
      expect(charge['amount']).to be_within(0.1).of(101)
    end

    it 'create redirect charge to merchant' do
      charge_hash = FactoryBot.build(:charge_redirect_peru, amount: 101, method: 'card')
      charge = @charges.create(charge_hash)
      #perform check
      redircet_charge = @charges.get(charge['id'])
      paymen_method = redircet_charge['payment_method']
      expect(paymen_method['type']).to eq('redirect')
      expect(redircet_charge['amount']).to be_within(0.1).of(101)
    end

    it 'create store charge to customer' do
      customer_hash = FactoryBot.build(:customer_pe)
      customer = @customers.create(customer_hash)
      charge_hash = FactoryBot.build(:charge_store_peru_customer, amount: 101, method: 'store')
      charge = @charges.create(charge_hash, customer['id'])
      paymen_method = charge['payment_method']
      expect(paymen_method['type']).to eq('store')
      expect(charge['customer_id']).to eq(customer['id'])
    end

    it 'create store charge to merchant' do
      charge_hash = FactoryBot.build(:charge_store_peru_merchant, amount: 101, method: 'store')
      charge = @charges.create(charge_hash)
      #perform check
      store_charge = @charges.get(charge['id'])
      paymen_method = store_charge['payment_method']
      expect(paymen_method['type']).to eq('store')
      expect(store_charge['amount']).to be_within(0.1).of(101)
    end

  end

  describe '.get' do
    it 'gets a merchant charge' do
      charge_hash = FactoryBot.build(:charge_redirect_peru, amount: 101, method: 'card')
      charge = @charges.create(charge_hash)
      #perform check
      redircet_charge = @charges.get(charge['id'])
      expect(redircet_charge['amount']).to be_within(0.1).of(101)
      #clean up
    end

    it 'gets a customer charge' do
      card_hash = FactoryBot.build(:valid_card_peru, holder_name: 'Pepe')
      customers = @openpay.create(:customers)
      customer_hash = FactoryBot.build(:customer_pe)
      customer = customers.create(customer_hash)
      #creates a customer card
      card = @cards.create(card_hash, customer['id'])
      charge_hash = FactoryBot.build(:charge_pe, source_id: card['id'], amount: 101)
      charge = @charges.create(charge_hash, customer['id'])

      #perform check
      stored_charge = @charges.get(charge['id'], customer['id'])
      expect(stored_charge['amount']).to be_within(0.5).of(101)
      #clean up
      @cards.delete(card['id'], customer['id'])
      # no se puede borrar usuario por transacciones asociadas
      # # @customers.delete(customer['id'])

    end

  end

  describe '.all' do

    it 'all merchant charges' do
      #TODO test can be improved,  but since charges cannot be deleted it make this difficult
      expect(@charges.all.size).to be_a Integer
    end

    it 'all customer charges' do
      #create new customer
      customer_hash = FactoryBot.build(:customer_pe)
      customer = @customers.create(customer_hash)
      expect(@charges.all(customer['id']).size).to be 0
      @customers.delete(customer['id'])

    end

  end

  describe '.refund' do
    #Refunds apply only for card charges
    it 'refunds  an existing merchant charge' do

    end

    it 'refunds an existing customer charge' do

    end

  end

  describe '.list' do

    it 'list customer charges' do
      #create new customer
      customer_hash = FactoryBot.build(:customer_pe)
      customer = @customers.create(customer_hash)
      #create customer card
      card_hash = FactoryBot.build(:valid_card_peru)
      card = @cards.create(card_hash, customer['id'])
      #create charge
      charge_hash = FactoryBot.build(:charge_pe, source_id: card['id'], order_id: card['id'])
      charge = @charges.create(charge_hash, customer['id'])
      charge_hash = FactoryBot.build(:charge_pe, source_id: card['id'], order_id: card['id'] + "1")
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
      customer_hash = FactoryBot.build(:customer_pe)
      customer = @customers.create(customer_hash)
      #create customer card
      card_hash = FactoryBot.build(:valid_card_peru)
      card = @cards.create(card_hash, customer['id'])
      #create charge
      charge_hash = FactoryBot.build(:charge_pe, source_id: card['id'], order_id: card['id'], amount: 4)
      @charges.create(charge_hash, customer['id'])
      charge2_hash = FactoryBot.build(:charge_pe, source_id: card['id'], order_id: card['id' + "2"], amount: 4)
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

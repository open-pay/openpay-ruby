require_relative '../../spec_helper'

describe CheckoutsPe do

  before(:all) do
    @merchant_id = 'm3cji4ughukthjcsglv0'
    @private_key = 'sk_f934dfe51645483e82106301d985a4f6'
    @openpay = OpenpayApi.new(@merchant_id, @private_key, "pe")
    @customers = @openpay.create(:customers)
    #LOG.level=Logger::DEBUG
    @charges = @openpay.create(:charges)
    @cards = @openpay.create(:cards)
    @checkouts = @openpay.create(:checkouts)

  end

  it 'has all required methods' do
    %w(all each create get list delete).each do |meth|
      expect(@checkouts).to respond_to(meth)
    end
  end

  describe '.create' do
    it 'create checkout to customer' do
      customer_hash = FactoryBot.build(:customer_pe)
      customer = @customers.create(customer_hash)
      checkout_hash = FactoryBot.build(:checkou_peru, order_id: customer['id'])
      checkout = @checkouts.create(checkout_hash, customer['id'])
      expect(checkout['id']).not_to be(nil)
    end

    it 'create charge to merchant' do
      customer_hash = FactoryBot.build(:customer_pe)
      customer = @customers.create(customer_hash)
      checkout_hash = FactoryBot.build(:checkou_peru_merchant, order_id: customer['id'])
      checkout = @checkouts.create(checkout_hash)
      expect(checkout['id']).not_to be(nil)
    end

  end

  describe '.get' do
    it 'get a checkout merchant with id' do
      customer_hash = FactoryBot.build(:customer_pe)
      customer = @customers.create(customer_hash)
      checkout_hash = FactoryBot.build(:checkou_peru, order_id: customer['id'])
      checkout = @checkouts.create(checkout_hash, customer['id'])
      checkout_res = @checkouts.get(checkout['id'])
      expect(checkout_res['id']).to match checkout['id']
    end

    it 'get a checkout with order id' do
      # customer_hash = FactoryBot.build(:customer_pe)
      # customer = @customers.create(customer_hash)
      # checkout_hash = FactoryBot.build(:checkou_peru, order_id: customer['id'])
      # checkout = @checkouts.create(checkout_hash, customer['id'])
      checkout_res = @checkouts.get_by_order_id('aqqgegs57695gysyedkh')
      expect(checkout_res['id']).to match checkout['id']
    end

  end

  describe '.all' do

    it 'all merchant checkouts' do
      checkouts_size = @checkouts.all.size
      expect(checkouts_size).to be_between(10, 100)
    end

  end
end

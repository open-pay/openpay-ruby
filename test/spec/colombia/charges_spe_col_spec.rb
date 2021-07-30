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

    it 'create charge SPE with existing client ' do
      #create card
      customer_hash = FactoryBot.build(:customer_col)
      customer = @customers.create(customer_hash)
      charge_hash = FactoryBot.build(:charge_pse_col, amount: 101)
      charge = @charges.create(charge_hash, customer['id'])
      #perform check
      spe_charge = @charges.get(charge['id'])
      method = spe_charge['method']
      payment_method = spe_charge['payment_method']
      expect(method).to eq('bank_account')
      expect(payment_method['type']).to eq('redirect')
    end

    it 'create charge SPE with new client ' do
      charge_hash = FactoryBot.build(:charge_pse_new_client_col, amount: 101)
      charge = @charges.create(charge_hash)
      #perform check
      spe_charge = @charges.get(charge['id'])
      method = spe_charge['method']
      payment_method = spe_charge['payment_method']
      expect(method).to eq('bank_account')
      expect(payment_method['type']).to eq('redirect')
    end

  end

end

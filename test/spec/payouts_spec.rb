require_relative '../spec_helper'

describe Payouts do

  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'
    
    #LOG.level=Logger::DEBUG

    @openpay=OpenpayApi.new(@merchant_id, @private_key)
    @payouts=@openpay.create(:payouts)

    @customers=@openpay.create(:customers)
    @cards=@openpay.create(:cards)
    @charges=@openpay.create(:charges)

    @bank_accounts=@openpay.create(:bankaccounts)

    @fees=@openpay.create(:fees)

  end

  it 'has all required methods' do
    %w(all each create get list delete).each do |meth|
      expect(@cards).to respond_to(meth)
    end
  end

  describe '.create' do

    skip 'creates a merchant payout' do
      #pending("is a pending example")
      #create merchant card
      card_hash = FactoryBot.build(:valid_card)
      card = @cards.create(card_hash)

      #create charge
      charge_hash=FactoryBot.build(:card_charge, source_id: card['id'], order_id: card['id'])
      charge=@charges.create(charge_hash)

      payout_hash=FactoryBot.build(:payout_card, destination_id: card['id'], amount: 100)

      payout=@payouts.create(payout_hash)
      expect(@payouts.get(payout['id'])['amount']).to be_within(0.1).of(100)

      @cards.delete(card['id'])
    end
    
    skip 'creates a customer payout using a card' do
      #We need to charge 1st into the card we are going to use

      #create new customer
      customer_hash=FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #create new customer card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #create charge
      charge_hash=FactoryBot.build(:card_charge, source_id: card['id'], order_id: card['id'])
      charge=@charges.create(charge_hash, customer['id'])

      payout_hash=FactoryBot.build(:payout_card, destination_id: card['id'], amount: 400)

      payout=@payouts.create(payout_hash, customer['id'])
      expect(@payouts.get(payout['id'], customer['id'])['amount']).to be_within(0.1).of(400)

      #cleanup
      @cards.delete_all(customer['id'])
      @bank_accounts.delete_all(customer['id'])

    end
    skip 'creates a customer payout using a bank account' do

      #create new customer
      customer_hash=FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #create new customer card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #create new customer bank account
      account_hash=FactoryBot.build(:bank_account)
      account=@bank_accounts.create(account_hash, customer['id'])

      #create charge
      charge_hash=FactoryBot.build(:card_charge, source_id: card['id'], order_id: card['id'])
      charge=@charges.create(charge_hash, customer['id'])

      payout_hash=FactoryBot.build(:payout_card, destination_id: account['id'], amount: 400)

      payout=@payouts.create(payout_hash, customer['id'])
      expect(@payouts.get(payout['id'], customer['id'])['amount']).to be_within(0.1).of(400)

      #cleanup
      @cards.delete_all(customer['id'])
      @bank_accounts.delete_all(customer['id'])
      # @customers.delete_all
    end
  end

  describe '.get' do

    skip 'gets a merchant payout' do
      #pending("is a pending example")
      payout_hash= FactoryBot.build(:payout_card, destination_id: 'bxz8ixftukkkjnrnypzb', amount: 10)
      payout=@payouts.create(payout_hash)
      expect(@payouts.get(payout['id'])['amount']).to be_within(0.1).of(10)
    end

    skip 'gets a customer payout' do
      #create new customer
      customer_hash= FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #create new customer card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #create charge
      charge_hash=FactoryBot.build(:card_charge, source_id: card['id'], order_id: card['id'])
      charge=@charges.create(charge_hash, customer['id'])

      payout_hash= FactoryBot.build(:payout_card, destination_id: card['id'], amount: 40)

      payout=@payouts.create(payout_hash, customer['id'])

      res=@payouts.get(payout['id'], customer['id'])
      expect(res['amount']).to be_within(0.1).of(40)

      #cleanup
      @cards.delete_all(customer['id'])
      @bank_accounts.delete_all(customer['id'])
      #@customers.delete_all
    end
  end

  describe '.all' do

    skip 'all merchant payouts' do
      #pending("is a pending example")
      expect(@payouts.all.size).to be_a Integer
      expect(@payouts.all.last['transaction_type']).to match 'payout'
    end

    skip 'all customer payouts' do
      #create new customer
      customer_hash= FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #create new customer card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #create charge
      charge_hash=FactoryBot.build(:card_charge, source_id: card['id'], order_id: card['id'])
      charge=@charges.create(charge_hash, customer['id'])

      payout_hash= FactoryBot.build(:payout_card, destination_id: card['id'], amount: 40)

      payout=@payouts.create(payout_hash, customer['id'])

      res=@payouts.get(payout['id'], customer['id'])
      expect(res['amount']).to be_within(0.1).of(40)

      expect(@payouts.all(customer['id']).last['transaction_type']).to match 'payout'

      #cleanup
      @cards.delete_all(customer['id'])
      @bank_accounts.delete_all(customer['id'])
    end

  end


  describe '.list' do

    skip 'list payouts given the filter' do

      #create new customer
      customer_hash= FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #create new customer card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #create charge
      charge_hash=FactoryBot.build(:card_charge, source_id: card['id'], order_id: card['id'])
      charge=@charges.create(charge_hash, customer['id'])

      payout_hash= FactoryBot.build(:payout_card, destination_id: card['id'], amount: 40)

      payout1=@payouts.create(payout_hash, customer['id'])
      payout2=@payouts.create(payout_hash, customer['id'])

      search_params = OpenpayUtils::SearchParams.new
      search_params.limit = 1

      expect(@payouts.all(customer['id']).size).to eq 2
      expect(@payouts.list(search_params, customer['id']).size).to eq 1

      #cleanup
      @cards.delete_all(customer['id'])
      @bank_accounts.delete_all(customer['id'])

    end

  end

  describe '.each' do

    it 'iterates over all merchant payouts' do
      @payouts.each do |pay|
        expect(@payouts.get(pay['id'])['transaction_type']).to match 'payout'
      end
    end

    it 'iterates over a given customer payouts' do
      a_customer=@customers.all.last
      @payouts.each(a_customer['id']) do |pay|
        expect(@payouts.get(pay['id'], a_customer['id'])['transaction_type']).to match 'payout'
      end
    end
  end
end

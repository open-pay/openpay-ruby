require_relative 'spec_helper'

describe Subscriptions do

  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'
    
    #LOG.level=Logger::DEBUG

    @openpay=OpenpayApi.new(@merchant_id, @private_key)
    @customers=@openpay.create(:customers)
    @cards=@openpay.create(:cards)
    @charges=@openpay.create(:charges)

    @plans=@openpay.create(:plans)

    @subscriptions=@openpay.create(:subscriptions)

  end

  it 'has all required methods' do
    %w(all each create get list delete).each do |meth|
      expect(@subscriptions).to respond_to(meth)
    end
  end

  describe '.create' do

    it 'creates a subscription' do

      #creates a customer
      customer_hash=FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #creates a customer card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #creates a plan
      plan_hash=FactoryBot.build(:plan, repeat_every: 5, amount: 500)
      plan=@plans.create(plan_hash)

      #creates subscription
      subscription_hash=FactoryBot.build(:subscription, plan_id: plan['id'], card_id: card['id'])
      subscription=@subscriptions.create(subscription_hash, customer['id'])

      #performs check
      saved_subscription=@subscriptions.get(subscription['id'], customer['id'])
      expect(saved_subscription['plan_id']).to eq(plan['id'])

      #cleanup
      @subscriptions.delete(subscription['id'], customer['id'])

    end

  end

  describe '.get' do

    it 'gets customer subscriptions' do

      #creates a customer
      customer_hash=FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #creates a customer  card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #creates a plan
      plan_hash=FactoryBot.build(:plan, repeat_every: 5, amount: 500)
      plan=@plans.create(plan_hash)

      #creates subscription
      subscription_hash=FactoryBot.build(:subscription, plan_id: plan['id'], card_id: card['id'])
      subscription=@subscriptions.create(subscription_hash, customer['id'])

      #get customer subscription
      stored_s=@subscriptions.get(subscription['id'], customer['id'])

      #performs check
      expect(stored_s['status']).to match 'trial'

      #cleanup
      @subscriptions.delete(subscription['id'], customer['id'])

    end

  end

  describe '.update' do

    it 'updates customer subscription' do

      time = Time.now + (60*60*24*2);
      time = time.strftime("%Y-%m-%d")
      #creates a customer
      customer_hash=FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #creates a customer  card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #creates a plan
      plan_hash=FactoryBot.build(:plan, repeat_every: 5, amount: 500)
      plan=@plans.create(plan_hash)

      #creates subscription
      subscription_hash=FactoryBot.build(:subscription, plan_id: plan['id'], card_id: card['id'])
      subscription=@subscriptions.create(subscription_hash, customer['id'])

      #get customer subscription
      stored_s=@subscriptions.get(subscription['id'], customer['id'])

      #performs check
      expect(stored_s['status']).to match 'trial'
      subscription_update_hash={ trial_end_date: time }
      sleep(20)
      stored_s=@subscriptions.update(subscription['id'], customer['id'], subscription_update_hash)
      expect(stored_s['trial_end_date']).to eq time

      #cleanup
      @subscriptions.delete(subscription['id'], customer['id'])

    end

  end

  describe '.all' do

    it 'returns all subscriptions for a given customer' do

      #creates a customer
      customer_hash= FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #creates a customer  card
      card_hash= FactoryBot.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #creates a plan
      plan_hash= FactoryBot.build(:plan, repeat_every: 5, amount: 500)
      plan=@plans.create(plan_hash)

      #creates subscription
      subscription_hash= FactoryBot.build(:subscription, plan_id: plan['id'], card_id: card['id'])
      expect(@subscriptions.all(customer['id']).size).to be 0
      subscription=@subscriptions.create(subscription_hash, customer['id'])

      #performs check
      expect(@subscriptions.all(customer['id']).size).to be 1

      #cleanup
      @subscriptions.delete(subscription['id'], customer['id'])

    end

  end

  describe '.list' do

    it 'list subscriptions based on given filter' do
      #creates a customer
      customer_hash= FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #creates a customer card
      card_hash= FactoryBot.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #creates a plan
      plan_hash= FactoryBot.build(:plan, repeat_every: 5, amount: 500)
      plan=@plans.create(plan_hash)

      #creates subscription
      subscription_hash= FactoryBot.build(:subscription, plan_id: plan['id'], card_id: card['id'])
      expect(@subscriptions.all(customer['id']).size).to be 0
      subscription1=@subscriptions.create(subscription_hash, customer['id'])
      subscription2=@subscriptions.create(subscription_hash, customer['id'])

      #performs check
      expect(@subscriptions.all(customer['id']).size).to be 2

      search_params = OpenpayUtils::SearchParams.new
      search_params.limit = 1
      expect(@subscriptions.all(customer['id']).size).to be 2
      expect(@subscriptions.list(search_params, customer['id']).size).to be 1

      #cleanup
      @subscriptions.delete(subscription1['id'], customer['id'])
      @subscriptions.delete(subscription2['id'], customer['id'])
    end

  end

  describe '.each' do

    it 'iterates over all subscriptions for a given customer' do

      #creates a customer
      customer_hash= FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #creates a customer  card
      card_hash= FactoryBot.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #creates a plan
      plan_hash= FactoryBot.build(:plan, repeat_every: 5, amount: 500)
      plan=@plans.create(plan_hash)

      #creates subscription
      subscription_hash= FactoryBot.build(:subscription, plan_id: plan['id'], card_id: card['id'])
      expect(@subscriptions.all(customer['id']).size).to be 0
      @subscriptions.create(subscription_hash, customer['id'])

      #performs check
      @subscriptions.each(customer['id']) do |stored_s|
          #check and clean
          expect(stored_s['status']).to match 'trial'
          @subscriptions.delete(stored_s['id'],customer['id'])
       end
      expect(@subscriptions.all(customer['id']).size).to be 0

    end

  end

  describe '.delete'  do

    it 'deletes an existing subscription for a given customer' do

      #creates a customer
      customer_hash= FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #creates a customer  card
      card_hash= FactoryBot.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #creates a plan
      plan_hash= FactoryBot.build(:plan, repeat_every: 5, amount: 500)
      plan=@plans.create(plan_hash)

      #creates subscription
      subscription_hash= FactoryBot.build(:subscription, plan_id: plan['id'], card_id: card['id'])
      expect(@subscriptions.all(customer['id']).size).to be 0
      subscription=@subscriptions.create(subscription_hash, customer['id'])

      #performs check
      expect(@subscriptions.all(customer['id']).size).to be 1

      #cleanup
      @subscriptions.delete(subscription['id'], customer['id'])

    end

  end

  describe '.delete_all' do

    it 'deletes all existing subscription for a given customer' do

      #creates a customer
      customer_hash= FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #creates a customer card
      card_hash= FactoryBot.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #creates a plan
      plan_hash= FactoryBot.build(:plan, repeat_every: 5, amount: 500)
      plan=@plans.create(plan_hash)

      #creates subscriptions
      subscription_hash= FactoryBot.build(:subscription, plan_id: plan['id'], card_id: card['id'])
      expect(@subscriptions.all(customer['id']).size).to be 0
      @subscriptions.create(subscription_hash, customer['id'])
      @subscriptions.create(subscription_hash, customer['id'])

      #perform check and clean up
      expect(@subscriptions.all(customer['id']).size).to be 2
      @subscriptions.delete_all(customer['id'])
      expect(@subscriptions.all(customer['id']).size).to be 0

    end

   end

end

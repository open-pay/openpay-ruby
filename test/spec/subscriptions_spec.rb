require '../spec_helper'

describe Subscriptions do


  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'

    @openpay=OpenpayApi.new(@merchant_id, @private_key)
    @customers=@openpay.create(:customers)
    @cards=@openpay.create(:cards)
    @charges=@openpay.create(:charges)

    @plans=@openpay.create(:plans)

    @subscriptions=@openpay.create(:subscriptions)

  end


  after(:all) do

  end


  describe '.create' do

    it 'creates a subscription' do


      #creates a customer
      customer_hash= FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)

      #creates a customer  card
      card_hash= FactoryGirl.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #creates a plan
      plan_hash= FactoryGirl.build(:plan, repeat_every: 5, amount: 500)
      plan=@plans.create(plan_hash)

      subscription_hash= FactoryGirl.build(:subscription, plan_id: plan['id'], card_id: card['id'])

      subscription=@subscriptions.create(subscription_hash, customer['id'])
      @subscriptions.delete(subscription['id'], customer['id'])


    end


  end


  describe '.get' do

    it 'gets customer subscriptions' do

      #creates a customer
      customer_hash= FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)

      #creates a customer  card
      card_hash= FactoryGirl.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #creates a plan
      plan_hash= FactoryGirl.build(:plan, repeat_every: 5, amount: 500)
      plan=@plans.create(plan_hash)

      subscription_hash= FactoryGirl.build(:subscription, plan_id: plan['id'], card_id: card['id'])

      subscription=@subscriptions.create(subscription_hash, customer['id'])


      stored_s=@subscriptions.get(subscription['id'], customer['id'])

      expect(stored_s['status']).to match 'trial'

      #clean up
      @subscriptions.delete(subscription['id'], customer['id'])


    end


  end


  describe '.all' do

    it 'returns all subscriptions for a given customer' do


      #creates a customer
      customer_hash= FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)

      #creates a customer  card
      card_hash= FactoryGirl.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #creates a plan
      plan_hash= FactoryGirl.build(:plan, repeat_every: 5, amount: 500)
      plan=@plans.create(plan_hash)

      subscription_hash= FactoryGirl.build(:subscription, plan_id: plan['id'], card_id: card['id'])

      expect(@subscriptions.all(customer['id']).size).to be 0


      subscription=@subscriptions.create(subscription_hash, customer['id'])


      expect(@subscriptions.all(customer['id']).size).to be 1

      #clean up
      @subscriptions.delete(subscription['id'], customer['id'])


    end


  end




  describe '.each' do

    it 'iterates over all subscriptions for a given customer' do


      #creates a customer
      customer_hash= FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)

      #creates a customer  card
      card_hash= FactoryGirl.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #creates a plan
      plan_hash= FactoryGirl.build(:plan, repeat_every: 5, amount: 500)
      plan=@plans.create(plan_hash)

      subscription_hash= FactoryGirl.build(:subscription, plan_id: plan['id'], card_id: card['id'])

      expect(@subscriptions.all(customer['id']).size).to be 0


      subscription=@subscriptions.create(subscription_hash, customer['id'])

      @subscriptions.each(customer['id']) do |stored_s|

             expect(stored_s['status']).to match 'trial'
             @subscriptions.delete(stored_s['id'],customer['id'])
       end


      expect(@subscriptions.all(customer['id']).size).to be 0


    end


  end





  describe '.delete'  do

    it 'deletes an existing subscription for a given customer' do


      #creates a customer
      customer_hash= FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)

      #creates a customer  card
      card_hash= FactoryGirl.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #creates a plan
      plan_hash= FactoryGirl.build(:plan, repeat_every: 5, amount: 500)
      plan=@plans.create(plan_hash)

      subscription_hash= FactoryGirl.build(:subscription, plan_id: plan['id'], card_id: card['id'])

      expect(@subscriptions.all(customer['id']).size).to be 0


      subscription=@subscriptions.create(subscription_hash, customer['id'])


      expect(@subscriptions.all(customer['id']).size).to be 1

      #clean up
      @subscriptions.delete(subscription['id'], customer['id'])

    end



  end


  describe '.delete_all' do



    it 'deletes all existing subscription for a given customer' do



      #creates a customer
      customer_hash= FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)

      #creates a customer  card
      card_hash= FactoryGirl.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #creates a plan
      plan_hash= FactoryGirl.build(:plan, repeat_every: 5, amount: 500)
      plan=@plans.create(plan_hash)

      subscription_hash= FactoryGirl.build(:subscription, plan_id: plan['id'], card_id: card['id'])

      expect(@subscriptions.all(customer['id']).size).to be 0


      subscription=@subscriptions.create(subscription_hash, customer['id'])
      subscription=@subscriptions.create(subscription_hash, customer['id'])



      expect(@subscriptions.all(customer['id']).size).to be 2

      #perform check and clean up
      @subscriptions.delete_all(customer['id'])
      expect(@subscriptions.all(customer['id']).size).to be 0




    end





    end





end








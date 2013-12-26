
require '../spec_helper'

describe Charges do




  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'

    @openpay=OpenPayApi.new(@merchant_id,@private_key)
    @customers=@openpay.create(:customers)

    @charges=@openpay.create(:charges)
    @cards=@openpay.create(:cards)
    @bank_accounts=@openpay.create(:bankaccounts)



  end


  after(:all) do
    @cards.delete_all
    @charges.delete_all
    @customers.delete_all
  end



  describe '.create' do

    it 'creates a new merchant charge using the card method using a pre-stored card' do


      #create card
      card_hash=FactoryGirl.build(:valid_card)
      card=@cards.create(card_hash)

      #create charge attached to prev created card
      charge_hash=FactoryGirl.build(:card_charge, source_id: card['id'], order_id: card['id'],amount: 101)
      charge=@charges.create(charge_hash)

      #perform check
      stored_charge=@charges.get(charge['id'])
      expect(stored_charge['amount']).to be_within(0.1).of(101)

     #clean up
      @cards.delete(card['id'])


    end


    it 'creates a new customer charge using the card method using a pre-stored card' do

      #create new customer
      customer_hash= FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)

      #create customer card
      card_hash=FactoryGirl.build(:valid_card)
      card=@cards.create(card_hash,customer['id'])

      #create charge
      charge_hash=FactoryGirl.build(:card_charge, source_id:card['id'],order_id: card['id'])
      charge=@charges.create(charge_hash,customer['id'])

      #perform check
      stored_charge=@charges.get(charge['id'],customer['id'])
      expect(stored_charge['amount']).to be_within(0.1).of(100)

      #clean up
      @cards.delete(card['id'],customer['id'])
      @customers.delete(customer['id'])

    end

    it 'creates a new customer charge using the card method using a new card' do
      pending

    end


    it 'creates a new customer charge using the bank_account method' do

      #create new customer
      customer_hash= FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)

      #create bank account
      account_hash=FactoryGirl.build(:bank_account)
      account=@bank_accounts.create(account_hash,customer['id'])

      #create charge
      charge_hash=FactoryGirl.build(:bank_charge, source_id:account['id'],order_id: account['id'])
      charge=@charges.create(charge_hash,customer['id'])

      #perform check
      stored_charge=@charges.get(charge['id'],customer['id'])
      expect(stored_charge['amount']).to be_within(0.1).of(10000)

      #clean up
      @bank_accounts.delete(customer['id'],account['id'])
      @customers.delete(customer['id'])

    end



  end



  describe '.get' do


    it 'gets a merchant charge'  do


      #create card
      card_hash=FactoryGirl.build(:valid_card)
      card=@cards.create(card_hash)

      #create charge attached to prev created card
      charge_hash=FactoryGirl.build(:card_charge, source_id: card['id'], order_id: card['id'],amount: 505)
      charge=@charges.create(charge_hash)

      #perform check
      stored_charge=@charges.get(charge['id'])
      expect(stored_charge['amount']).to be_within(0.1).of(505)

      #clean up
      @cards.delete(card['id'])



    end


    it  'gets a customer charge' do

      #create new customer
      customer_hash= FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)

      #create customer card
      card_hash=FactoryGirl.build(:valid_card)
      card=@cards.create(card_hash,customer['id'])

      #create charge
      charge_hash=FactoryGirl.build(:card_charge, source_id:card['id'],order_id: card['id'],amount: 4000)
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

    it 'list all merchant charges' do

      #TODO test can be improved,  but since charges cannot be deleted it make this difficult
      expect(@charges.all.size).to be_a Integer

   end


    it 'list all customer charges' do
      #create new customer
      customer_hash= FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)


      expect(@charges.all(customer['id']).size).to be 0
      @customers.delete(customer['id'])


    end

  end




  describe '.cancel' do

    it 'cancels an existing merchant charge'  do

      pending 'check if the cancel method in reality works, documentation has some discrepancies'
      #create card
      card_hash=FactoryGirl.build(:valid_card)
      card=@cards.create(card_hash)

      #create charge attached to prev created card
      charge_hash=FactoryGirl.build(:card_charge, source_id: card['id'], order_id: card['id'],amount: 1505)
      charge=@charges.create(charge_hash)

      #perform check
      stored_charge=@charges.get(charge['id'])
      expect(stored_charge['amount']).to be_within(0.1).of(1505)

      #cancel charge
      @charges.cancel(charge['id'])
     p  stored_charge=@charges.get(charge['id'])



      #clean up
      @cards.delete(card['id'])


    end



    it 'cancels an existing customer charge'  do
      pending 'check if the cancel method in reality works, documentation has some discrepancies'

      #create new customer
      customer_hash= FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)

      #create customer card
      card_hash=FactoryGirl.build(:valid_card)
      card=@cards.create(card_hash,customer['id'])

      #create charge
      charge_hash=FactoryGirl.build(:card_charge, source_id:card['id'],order_id: card['id'],amount: 4000)
      charge=@charges.create(charge_hash,customer['id'])

      #perform check
      stored_charge=@charges.get(charge['id'],customer['id'])
      expect(stored_charge['amount']).to be_within(0.5).of(4000)

      #cancel
      @charges.cancel(customer['id'],charge['id'])
    p   stored_charge=@charges.get(charge['id'],customer['id'])



      #clean up
      @cards.delete(card['id'],customer['id'])
      @customers.delete(customer['id'])

    end



  end




  describe '.capture' do

    it 'captures  an existing merchant charge'  do
      pending 'check if the cancel method in reality works, documentation has some discrepancies'

    end


    it 'fails to capture an non existing merchant charge' do
      pending 'check if the cancel method in reality works, documentation has some discrepancies'
    end



    it 'captures  an existing customer charge'  do
      pending 'check if the cancel method in reality works, documentation has some discrepancies'
    end


  end




  describe '.refund' do



    #Refunds apply only for card charges
    it 'refunds  an existing merchant charge'  do
      #create card
      card_hash=FactoryGirl.build(:valid_card)
      card=@cards.create(card_hash)

      #create charge attached to prev created card
      charge_hash=FactoryGirl.build(:card_charge, source_id: card['id'], order_id: card['id'],amount: 505)
      charge=@charges.create(charge_hash)

      #creates refund_description
      refund_description=FactoryGirl.build(:refund_description)
      expect(@charges.get(charge['id'])['refund']).to be nil

      @charges.refund(charge['id'],refund_description)
      expect(@charges.get(charge['id'])['refund']['amount'] ).to be_within(0.1).of(505)


      #clean up
      @cards.delete(card['id'])

    end


    it 'fails to refunds an non existing merchant charge' do
      pending
    end



    it 'refunds  an existing customer charge'  do
      #create new customer
      customer_hash= FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)

      #create customer card
      card_hash=FactoryGirl.build(:valid_card)
      card=@cards.create(card_hash,customer['id'])

      #create charge
      charge_hash=FactoryGirl.build(:card_charge, source_id:card['id'],order_id: card['id'],amount: 4000)
      charge=@charges.create(charge_hash,customer['id'])

      #creates refund_description
      refund_description=FactoryGirl.build(:refund_description)


      #perform check
      expect(@charges.get(charge['id'],customer['id'])['refund']).to be nil
      @charges.refund(charge['id'],refund_description,customer['id'])
      expect(@charges.get(charge['id'],customer['id'])['refund']['amount'] ).to be_within(0.1).of(4000)

      #clean up
      @cards.delete(card['id'],customer['id'])
      @customers.delete(customer['id'])




    end

    it 'fails to refund an non existing customer charge' do
      pending
    end


  end









  describe '.list' do


    it 'list merchant charges' do

         pending

    end



    it 'list customer charges' do
      pending

    end


  end


  describe '.each' do

    it 'iterates over merchant charges' do
      pending
    end



    it 'iterate over customer charges' do
      pending
    end


  end








end
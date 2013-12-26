
require '../spec_helper'

describe Payouts do




  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'

    @openpay=OpenPayApi.new(@merchant_id, @private_key)
    @payout=@openpay.create(:payouts)

    @customers=@openpay.create(:customers)
    @cards=@openpay.create(:cards)
    @charges=@openpay.create(:charges)

    @bank_accounts=@openpay.create(:bankaccounts)

    @fees=@openpay.create(:fees)



  end




  describe '.create' do

    it 'creates a merchant payout' do

      payout_hash= FactoryGirl.build(:payout_card, destination_id: 'b4ravkgvpir9izop1faz',amount: 100)

     p  payout=@payout.create(payout_hash)
      expect(@payout.get(payout['id'])['amount']).to be_within(0.1).of(100)




    end


    it 'creates a merchant payout into a customer bank account' do

      pending
      #create new customer
      customer_hash= FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)

      #create customer bankaccount
      account_hash=FactoryGirl.build(:bank_account)
      account=@bank_accounts.create(account_hash, customer['id'])



      payout_hash= FactoryGirl.build(:payout_bank_account, destination_id: account['id'],amount: 400)
      #  payout_hash= FactoryGirl.build(:payout_card, destination_id: account['id'])

     p payout=@payout.create(payout_hash)
      expect(@payout.get(payout['id'])).to be_within(0.1).of(400)





      #clenup
      @cards.delete_all
       @bank_accounts.delete_all(customer['id'])
      @customers.delete_all



    end

      it 'creates a customer to customer payout' do
        #create new customer
        customer_hash= FactoryGirl.build(:customer)
        customer=@customers.create(customer_hash)

        #create customer bankaccount
        account_hash=FactoryGirl.build(:bank_account)
        account=@bank_accounts.create(account_hash, customer['id'])


        #create charge
        charge_hash=FactoryGirl.build(:bank_charge, source_id:account['id'],order_id: account['id'])
        charge=@charges.create(charge_hash,customer['id'])

        #create  customer    2
        customer_hash= FactoryGirl.build(:customer)
        customer2=@customers.create(customer_hash)

        #create customer bankaccount 2
        account_hash=FactoryGirl.build(:bank_account,clabe:  '072324523452346231' )
        account2=@bank_accounts.create(account_hash, customer2['id'])


        #create charge
        charge_hash2=FactoryGirl.build(:bank_charge, source_id:account2['id'],order_id: account2['id'])
        charge=@charges.create(charge_hash2,customer['id'])


        payout_hash= FactoryGirl.build(:payout_bank_account, destination_id: account2['id'],amount: 400)
        #  payout_hash= FactoryGirl.build(:payout_card, destination_id: account['id'])

        payout=@payout.create(payout_hash,customer2['id'])
        expect(@payout.get(payout['id'])).to be_within(0.1).of(400)





        #clenup
        @cards.delete_all
        @bank_accounts.delete_all(customer['id'])
        @customers.delete_all
     end


  end

  describe '.get' do

    it 'get a merchant payout' do

             p   @payout.all

    end

    it 'get  a customer payout' do
      pending
    end


  end

  describe '.all' do

    it 'all merchant payouts' do
      pending
    end

    it 'all customer payout' do
      pending
    end

  end


  describe '.each' do

    it 'iterates over all merchant payouts' do
      pending
    end

    it 'iterates over  all customer payouts' do
      pending
    end

  end


end
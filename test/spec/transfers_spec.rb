require '../spec_helper'

describe Transfers do




  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'

    @openpay=OpenPayApi.new(@merchant_id, @private_key)
    @customers=@openpay.create(:customers)
    @cards=@openpay.create(:cards)
    @charges=@openpay.create(:charges)

    @bank_accounts=@openpay.create(:bankaccounts)
    @transfers=@openpay.create(:transfers)


  end

  describe '.create' do


    it 'transfers money from customer to customer' do


      #create new customer
      customer_hash= FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)

      #create bank account
      account_hash=FactoryGirl.build(:bank_account)
      account=@bank_accounts.create(customer['id'],account_hash)

      #create charge
      charge_hash=FactoryGirl.build(:bank_charge, source_id:account['id'],order_id: account['id'])
      charge=@charges.create(charge_hash,customer['id'])



      #create new customer
      customer_hash= FactoryGirl.build(:customer,name: 'Alejandro')
      customer2=@customers.create(customer_hash)
      #create bank account
      account_hash2=FactoryGirl.build(:bank_account)
      account2=@bank_accounts.create(customer2['id'],account_hash2)
      #create charge
      charge_hash=FactoryGirl.build(:bank_charge, source_id:account2['id'],order_id: account2['id'])
      charge=@charges.create(charge_hash,customer['id'])




      #create new transfer
      customer_hash= FactoryGirl.build(:transfer,customer_id: customer2['id'])


    p  @transfers.create(customer['id'],customer_hash)




    end





  end





  describe 'get' do


  end


  describe '.each' do


  end

  describe '.list' do



  end



  describe '.all' do


  end





end
require 'test/spec_helper'


describe  Bankaccounts do

 #bankaccounts for merchant cannot be created using the api
  #the merchant bank account should be created using the Openpay dashboard
  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'

    @openpay=OpenpayApi.new(@merchant_id,@private_key)
    @bank_accounts=@openpay.create(:bankaccounts)
    @customers=@openpay.create(:customers)

  end


  after(:all) do
    @customers.delete_all
    @bank_accounts.delete_all
  end

  describe '.create' do

    it 'creates  a customer bank account' do
      customer_hash= FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)

      account_hash=FactoryGirl.build(:bank_account)
      bank=@bank_accounts.create(account_hash,customer['id'])

      bank_account=@bank_accounts.get(customer['id'],bank['id'])
      expect(bank_account['alias']).to match 'Cuenta principal'

      @bank_accounts.delete(customer['id'],bank['id'])

    end

  end



  describe '.get' do

    it 'get a given bank account for a given customer' do

      customer_hash= FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)

      account_hash=FactoryGirl.build(:bank_account)
      bank=@bank_accounts.create(account_hash,customer['id'])

      bank_account=@bank_accounts.get(customer['id'],bank['id'])
      expect(bank_account['alias']).to match 'Cuenta principal'
      @bank_accounts.delete(customer['id'],bank['id'])

    end

  end



  describe '.each' do


    it 'iterator for  all given customer bank accounts' do

      customer_hash= FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)

      account_hash=FactoryGirl.build(:bank_account)
      bank=@bank_accounts.create(account_hash,customer['id'])

      @bank_accounts.each(customer['id']) do |bank_account|
          expect( bank_account['alias']).to match 'Cuenta principal'
      end

      @bank_accounts.delete(customer['id'],bank['id'])
      @customers.delete(customer['id'])

    end


end


  describe '.list' do

    it 'should list the bank accounts using a given filter' do
       pending
    end
  end



  describe '.all' do

    it 'list all bank accounts for a given customer' do

         customer_hash= FactoryGirl.build(:customer)
         customer=@customers.create(customer_hash)
         expect(@bank_accounts.all(customer['id']).size).to be 0

         account_hash=FactoryGirl.build(:bank_account)
         bank=@bank_accounts.create(account_hash,customer['id'])
         expect(@bank_accounts.all(customer['id']).size).to be 1

         @bank_accounts.delete(customer['id'],bank['id'])
         @customers.delete(customer['id'])

    end

    it 'fails to list all bank accounts when a non existing customer is given' do
      expect { @bank_accounts.all('11111') }.to raise_exception(OpenpayTransactionException)
    end

  end


  describe '.delete' do

    it 'deletes  a given  bank account' do

      customer_hash= FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)
      expect(@bank_accounts.all(customer['id']).size).to be 0


      account_hash=FactoryGirl.build(:bank_account)
      bank=@bank_accounts.create(account_hash,customer['id'])
      expect(@bank_accounts.all(customer['id']).size).to be 1

      @bank_accounts.delete(customer['id'],bank['id'])
      @customers.delete(customer['id'])

    end


    it 'fails to delete  a non existing  bank accounts' do
         expect { @customers.delete('1111') }.to raise_exception  OpenpayTransactionException
    end

  end


  describe '.delete_all' do

    it 'deletes all bank accounts' do

      customer_hash= FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)

      account_hash=FactoryGirl.build(:bank_account)

      @bank_accounts.create(account_hash,customer['id'])
      expect(@bank_accounts.all(customer['id']).size).to be 1

      @bank_accounts.delete_all(customer['id'])
      expect(@bank_accounts.all(customer['id']).size).to be 0


    end

    it 'fails to deletes all bank accounts when used on PROD' do

      @openpayprod=OpenpayApi.new(@merchant_id, @private_key, true)
      bank_accounts=@openpayprod.create(:bankaccounts)

      expect { bank_accounts.delete_all('111111') }.to raise_exception   OpenpayException


    end

  end










end

require '../spec_helper'


describe  Bankaccounts do



  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'

    @openpay=OpenPayApi.new(@merchant_id,@private_key)
    @bank_accounts=@openpay.create(:bankaccounts)
    @customers=@openpay.create(:customers)


  end



  after(:all) do
    @customers.delete_all!
    @bank_accounts.delete_all!

  end

  describe '.create' do

    it 'creates  a bank account' do
      customer_hash= FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)

      account_hash=FactoryGirl.build(:bank_account)
      bank=@bank_accounts.create(customer['id'],account_hash)

      bank_account=@bank_accounts.get(customer['id'],bank['id'])
      expect(bank_account['alias']).to match 'Cuenta principal'

      @bank_accounts.delete(customer['id'],bank['id'])








    end


  end



  describe '.get' do

    it 'get a given bank account' do

      customer_hash= FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)

      account_hash=FactoryGirl.build(:bank_account)
      bank=@bank_accounts.create(customer['id'],account_hash)

      bank_account=@bank_accounts.get(customer['id'],bank['id'])
      expect(bank_account['alias']).to match 'Cuenta principal'
      @bank_accounts.delete(customer['id'],bank['id'])







    end



  end





  describe '.each' do


    it 'iterator for  all bank accounts' do

      customer_hash= FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)

      account_hash=FactoryGirl.build(:bank_account)
      bank=@bank_accounts.create(customer['id'],account_hash)

      @bank_accounts.each(customer['id']) do |bank_account|

          expect( bank_account['alias']).to match 'Cuenta principal'

      end

      @bank_accounts.delete(customer['id'],bank['id'])

    end


end



  describe '.all' do

    it 'list all bank accounts' do

      pending

    end



  end






  describe '.delete' do

    it 'deletes  a given  bank accounts' do

      pending

    end


    it 'fails to delete  a given  bank accounts' do

      pending

    end

  end



  describe '.delete_all!' do

    it 'deletes all bank accounts' do

      @bank_accounts.delete_all!
      expect(@bank_accounts.all.size).to be 0

    end

    it 'fails to deletes all bank accounts when used on PROD' do

      pending

    end

  end










end
require_relative '../spec_helper'


describe Bankaccounts do

  #bankaccounts for merchant cannot be created using the api
  #the merchant bank account should be created using the Openpay dashboard
  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'

    @openpay=OpenpayApi.new(@merchant_id, @private_key, false, 30)
    @bank_accounts=@openpay.create(:bankaccounts)
    @customers=@openpay.create(:customers)

  end

  describe '.get' do

    it 'get a given bank account for a given customer' do

      customer_hash= FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)

      account_hash=FactoryGirl.build(:bank_account)
      bank=@bank_accounts.create(account_hash, customer['id'])

      bank_account=@bank_accounts.get(customer['id'], bank['id'])
      expect(bank_account['alias']).to match 'Cuenta principal'
      @bank_accounts.delete(customer['id'], bank['id'])
      @customers.delete(customer['id'])

    end

  end

end

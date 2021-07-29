require_relative '../spec_helper'

describe Bankaccounts do

  #bankaccounts for merchant cannot be created using the api
  #the merchant bank account should be created using the Openpay dashboard
  before(:all) do

    @merchant_id = 'mwf7x79goz7afkdbuyqd'
    @private_key = 'sk_94a89308b4d7469cbda762c4b392152a'

    #LOG.level=Logger::DEBUG

    @openpay = OpenpayApi.new(@merchant_id, @private_key, "co")
    @bank_accounts = @openpay.create(:bankaccounts)
    @customers = @openpay.create(:customers)

  end

  it 'has all required methods' do
    %w(all each create get list delete).each do |meth|
      expect(@bank_accounts).to respond_to(meth)
    end
  end
  describe '.list' do

    it 'list the bank accounts using a creation_gte filter' do

      customer_hash = FactoryBot.build(:customer_col)
      customer = @customers.create(customer_hash)
      bank_accounts = @bank_accounts.all(customer['id'])
      expect(bank_accounts.size).to be 0

      account_hash = FactoryBot.build(:bank_account)
      bank = @bank_accounts.create(account_hash, customer['id'])
      expect(@bank_accounts.all(customer['id']).size).to be 1

      search_params = OpenpayUtils::SearchParams.new
      search_params.limit = 1
      search_params.creation_gte = '2000-01-01'

      expect(@bank_accounts.all(customer['id']).size).to eq 1
      expect(@bank_accounts.list(search_params, customer['id']).size).to eq 1

      @bank_accounts.delete(customer['id'], bank['id'])
      @customers.delete(customer['id'])

    end
  end
end

require_relative '../../spec_helper'

describe Subscriptions do

  before(:all) do
    @merchant_id = 'mwf7x79goz7afkdbuyqd'
    @private_key = 'sk_94a89308b4d7469cbda762c4b392152a'
    #LOG.level=Logger::DEBUG
    @openpay = OpenpayApi.new(@merchant_id, @private_key, "co")
    @tokens = @openpay.create(:tokens)
  end

  it 'has all required methods' do
    %w(all each create get list delete).each do |meth|
      expect(@tokens).to respond_to(meth)
    end
  end

  describe '.create' do
    it 'creates a token' do
      token_hash = FactoryBot.build(:token_col)
      token = @tokens.create(token_hash)
      LOG.info token
      expect(token['id']).not_to be(nil)
    end
  end

  describe '.get' do
    it 'get token' do
      token_hash = FactoryBot.build(:token_col)
      token = @tokens.create(token_hash)
      LOG.info token
      token_result = @tokens.get(token['id'])
      LOG.info token_result
      expect(token['id']).to eq(token_result['id'])
    end
  end
end
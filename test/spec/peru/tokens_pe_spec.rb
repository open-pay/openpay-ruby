require_relative '../../spec_helper'

describe Subscriptions do

  before(:all) do
    @merchant_id = 'm3cji4ughukthjcsglv0'
    @private_key = 'sk_f934dfe51645483e82106301d985a4f6'
    #LOG.level=Logger::DEBUG
    @openpay = OpenpayApi.new(@merchant_id, @private_key, "pe")
    @tokens = @openpay.create(:tokens)
  end

  it 'has all required methods' do
    %w(all each create get list delete).each do |meth|
      expect(@tokens).to respond_to(meth)
    end
  end

  describe '.create' do
    it 'creates a token' do
      token_hash = FactoryBot.build(:token_peru)
      token = @tokens.create(token_hash)
      LOG.info token
      expect(token['id']).not_to be(nil)
    end
  end

  describe '.get' do
    it 'get token' do
      token_hash = FactoryBot.build(:token_peru)
      token = @tokens.create(token_hash)
      LOG.info token
      token_result = @tokens.get(token['id'])
      LOG.info token_result
      expect(token['id']).to eq(token_result['id'])
    end
  end
end
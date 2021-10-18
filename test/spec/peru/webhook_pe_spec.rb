require_relative '../../spec_helper'

describe Webhooks do

  before(:all) do
    @merchant_id = 'm3cji4ughukthjcsglv0'
    @private_key = 'sk_f934dfe51645483e82106301d985a4f6'
    #LOG.level=Logger::DEBUG
    @openpay = OpenpayApi.new(@merchant_id, @private_key, "pe")
    @webhooks = @openpay.create(:webhooks)
  end

  it 'has all required methods' do
    %w(all each create get list delete).each do |meth|
      expect(@webhooks).to respond_to(meth)
    end
  end

  describe '.create' do
    it 'creates a webhooks' do
      webhook_hash = FactoryBot.build(:webhook_peru)
      webhook = @webhooks.create(webhook_hash)
      LOG.info webhook
      expect(webhook['id']).not_to be(nil)
      @webhooks.delete(webhook['id'])
    end
  end

  describe '.get' do
    it 'get token' do
      webhook_hash = FactoryBot.build(:webhook_peru)
      webhook = @webhooks.create(webhook_hash)
      LOG.info webhook
      webhook_result = @webhooks.get(webhook['id'])
      LOG.info webhook_result
      expect(webhook_result['id']).to eq(webhook['id'])
      @webhooks.delete(webhook['id'])
    end
  end

  describe '.all' do
    it 'creates a webhooks' do
      webhook_hash = FactoryBot.build(:webhook_peru)
      webhook = @webhooks.create(webhook_hash)
      LOG.info webhook
      expect(@webhooks.all.size).to eq 1
      @webhooks.delete(webhook['id'])
    end
  end
end
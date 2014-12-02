require_relative '../spec_helper'

describe Webhooks do
  
  before(:all) do
    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'
    
    #LOG.level=Logger::DEBUG

    @openpay=OpenpayApi.new(@merchant_id, @private_key)
    @webhooks=@openpay.create(:webhooks)
  end

  after(:all) do
    @webhooks.delete_all
  end
  
  it 'has all required methods' do
    %w(all each create get list delete).each do |meth|
      expect(@webhooks).to respond_to(meth)
    end
  end
  
  describe '.create' do
    it 'creates a webhook' do
      webhook_hash= FactoryGirl.build(:webhook1)
      webhook=@webhooks.create(webhook_hash)
      #validates
      expect(@webhooks.get(webhook['id'])['url']).to eq('http://requestb.in/qozy7dqp')
      #clean
      @webhooks.delete(webhook['id'])
    end
  end
  
  describe '.get' do
    it 'fails to get a non existing customer plan' do
      #validates
      expect { @webhooks.get('111111') }.to raise_exception OpenpayTransactionException
      begin
        @webhooks.get('111111')
      rescue OpenpayTransactionException => e
        expect(e.description).to match 'The  merchant with id \'mywvupjjs9xdnryxtplq\' or the webhook with id \'111111\' does not exists.'
      end
    end
  end

  describe '.all' do
    it 'list all webhooks given the filter' do
      #creates a webhook
      webhook_hash1= FactoryGirl.build(:webhook1)
      webhook_hash2= FactoryGirl.build(:webhook2)
      webhook1=@webhooks.create(webhook_hash1)
      webhook2=@webhooks.create(webhook_hash2)
      expect(@webhooks.all().size).to eq 2
      #clean
      @webhooks.delete(webhook1['id'])
      @webhooks.delete(webhook2['id'])
    end
  end

  describe '.each' do
    it 'iterates over all webhooks' do
      #creates a webhook
      webhook_hash1= FactoryGirl.build(:webhook1)
      webhook_hash2= FactoryGirl.build(:webhook2)
      webhook1=@webhooks.create(webhook_hash1)
      webhook2=@webhooks.create(webhook_hash2)

      expect(@webhooks.all.size).to be_a Integer
      @webhooks.each do |webhook|
        expect(webhook['event_types']).to eq(['charge.succeeded','charge.created','charge.cancelled','charge.failed'])
        @webhooks.delete(webhook['id'])
      end
      expect(@webhooks.all.size).to be_a Integer
    end
  end
  
  
  describe '.verify' do
    it 'verify webhook and activate' do
     webhook_hash1= FactoryGirl.build(:webhook1)
     webhook1=@webhooks.create(webhook_hash1)
     
     puts webhook_hash1[:url] + '?inspect'
     res=RestClient::Request.new(
          :method => :post,
          :url => webhook_hash1[:url] + '?inspect',
          :timeout => @timeout,
          :headers => {:accept => :json,
                       :content_type => :json,
                       :user_agent => 'Openpay/v1  Ruby-API',
          }
        ).execute

     expect(@webhooks.get(webhook1['id'])['status']).to eq('unverified')
     verification_code = res[res.index('verification_code') + 28 , 8]
     request_hash=@webhooks.verify(webhook1['id'], verification_code)     
     expect(@webhooks.get(webhook1['id'])['status']).to eq('verified')

    end
  end
  
end
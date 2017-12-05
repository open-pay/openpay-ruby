require_relative 'spec_helper'

describe Plans do

  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'
    
    #LOG.level=Logger::DEBUG

    @openpay=OpenpayApi.new(@merchant_id, @private_key)
    @customers=@openpay.create(:customers)
    @plans=@openpay.create(:plans)
    @subscriptions=@openpay.create(:subscriptions)

  end

begin

  after(:all) do
    @plans.delete_all
  end

end 

  it 'has all required methods' do
    %w(all each create get list delete).each do |meth|
      expect(@plans).to respond_to(meth)
    end
  end

  describe '.create' do

    it 'creates a merchant plan' do

      plan_hash= FactoryBot.build(:plan, repeat_every: 5)
      plan=@plans.create(plan_hash)

      #validates
      expect(@plans.get(plan['id'])['repeat_every']).to be 5

      #clean
      @plans.delete(plan['id'])

    end

  end

  describe 'get' do

    it 'gets a merchant plan' do

      #creates a plan
      plan_hash= FactoryBot.build(:plan, repeat_every: 5, amount: 500)
      plan=@plans.create(plan_hash)

      #validates
      expect(@plans.get(plan['id'])['repeat_every']).to be 5
      expect(@plans.get(plan['id'])['amount']).to be_within(0.1).of(500)

      #clean
      @plans.delete(plan['id'])

    end

    it 'fails to get a non existing customer plan' do
      #validates
      expect { @plans.get('111111') }.to raise_exception OpenpayTransactionException
      begin
        @plans.get('111111')
      rescue OpenpayTransactionException => e
        expect(e.description).to match 'The requested resource doesn\'t exist'
      end

    end

  end

  describe '.all' do
    it 'returns all customer plans' do
      expect(@plans.all.size).to be_a Integer
    end
  end

  describe '.list' do
    it 'list all plans given the filter' do
      #creates a plan
      plan_hash= FactoryBot.build(:plan, repeat_every: 5, amount: 500)
      plan=@plans.create(plan_hash)

      search_params = OpenpayUtils::SearchParams.new
      search_params.limit = 1
      expect(@plans.list(search_params).size).to eq 1

      #clean
      @plans.delete(plan['id'])
    end

  end

  describe '.update' do

    it 'updates an existing customer plan' do
      #creates a plan
      plan_hash= FactoryBot.build(:plan, trial_days: 10)
      plan=@plans.create(plan_hash)

      expect(plan['trial_days']).to be 10
      plan_hash= FactoryBot.build(:plan, trial_days: 100)
      plan=@plans.update(plan_hash, plan['id'])
      expect(plan['trial_days']).to be 100

      #cleanup
      @plans.delete(plan['id'])
    end

    it 'fails to update an non existing customer plan' do

      plan_hash= FactoryBot.build(:plan, trial_days: 100)

      #validates
      expect { @plans.update(plan_hash, '111111') }.to raise_exception RestClient::ResourceNotFound
      begin
        @plans.update(plan_hash, '111111')
      rescue RestClient::ResourceNotFound => e
        expect(e.http_body).to be_a String
        expect(e.message).to include("404")
      end

    end

  end

  skip '.each' do

    it 'iterates over all customer plans' do

      #creates a plan
      plan_hash= FactoryBot.build(:plan, trial_days: 30)
      plan=@plans.create(plan_hash)
      plan1=@plans.create(plan_hash)
      plan2=@plans.create(plan_hash)

      expect(@plans.all.size).to be_a Integer
      @plans.each do |plan|
        expect(plan['name']).to match 'TODO INCLUIDO'
        @plans.delete(plan['id'])
      end

      expect(@plans.all.size).to be_a Integer

    end

  end

end

require_relative '../../spec_helper'

describe Customers do

  before(:all) do
    @merchant_id = 'm3cji4ughukthjcsglv0'
    @private_key = 'sk_f934dfe51645483e82106301d985a4f6'
    #LOG.level=Logger::DEBUG
    @openpay = OpenpayApi.new(@merchant_id, @private_key, "pe")
    @customers = @openpay.create(:customers)
  end

  after(:all) do
    # @customers.delete_all
  end

  it 'has all required methods' do
    %w(all each create get list delete).each do |meth|
      expect(@customers).to respond_to(meth)
    end
  end

  describe '.create' do
    it 'creates a customer' do
      #creates a new customer
      name = 'Juan'
      last_name = 'Peru'
      #json as input
      customer_json = FactoryBot.build(:customer_pe, name: name, last_name: last_name).to_json
      customer = @customers.create(customer_json)
      #perform check
      #json as output
      expect(customer).to have_json_path('name')
      #build hash out json string
      customer_hash = JSON.parse customer
      id = customer_hash['id']
      #perform check
      saved_customer = @customers.get(id)
      expect(saved_customer['name']).to match(name)
      expect(saved_customer['last_name']).to match(last_name)
      #cleanup
      @customers.delete(id)
    end

    it 'fails when passing invalid information' do
      #check no errors
      expect(@customers.errors?).to eq false
      #invalid email
      email = 'foo'
      customer_hash = FactoryBot.build(:customer_pe, email: email)
      #perform check
      expect { @customers.create(customer_hash) }.to raise_exception OpenpayTransactionException
      begin
        @customers.create(customer_hash)
      rescue OpenpayTransactionException => e
        expect(e.http_code).to be 400
        expect(e.description).to match /'foo' is not a valid email address/
      end
      expect(@customers.errors?).to eq true
    end

  end

  describe '.delete' do
    it 'deletes an existing customer' do
      #creates customer
      customer_hash = FactoryBot.build(:customer_pe, name: :delete_me)
      customer = @customers.create(customer_hash)
      id = customer['id']
      #delete customer
      @customers.delete(id)
      #perform check
      expect { @customers.get(id) }.to raise_exception OpenpayTransactionException
    end
  end

  describe '.get' do
    it 'get a customer' do
      #create customer
      name = 'get_test'
      customer_hash = FactoryBot.build(:customer_pe, name: name)
      customer = @customers.create(customer_hash)
      id = customer['id']
      #perform check
      expect(@customers.get(id)['name']).to match name
      #cleanup
      @customers.delete(id)
    end

  end

  describe '.each' do
    it 'list all customers' do
      @customers.each do |cust|
        expect(cust['id']).to match /.+/
      end
    end
  end

  describe '.update' do
    it 'updates an existing customer' do
      # creates customer
      name = 'customer_update_test'
      customer_hash = FactoryBot.build(:customer_pe, name: name)
      customer = @customers.create(customer_hash)
      id = customer['id']
      #update customer
      name = 'new_name'
      customer_hash = FactoryBot.build(:customer_pe, name: name)
      @customers.update(customer_hash, id)
      #perform check
      expect(@customers.get(id)['name']).to match name
      #cleanup
      @customers.delete(id)
    end
  end

  describe '.list' do
    it 'list customers given the filter' do
      # creates customer
      name = 'customer_update_test'
      customer_hash = FactoryBot.build(:customer_pe, name: name)
      customer = @customers.create(customer_hash)
      id = customer['id']
      search_params = OpenpayUtils::SearchParams.new
      search_params.limit = 1
      search_params.creation_gte = '2021-10-01'
      #perform check
      expect(@customers.list(search_params).size).to eq 1
      #cleanup
      @customers.delete(id)
    end
  end

  describe '.all' do
    it 'all the customers' do
      #initial state check
      initial_num = @customers.all.size
      # creates customer
      name = 'customer_update_test'
      customer_hash = FactoryBot.build(:customer_pe, name: name)
      customer = @customers.create(customer_hash)
      #performs check
      expect(@customers.all.size).to eq initial_num
      #cleanup
      @customers.delete(customer['id'])
    end
  end

end


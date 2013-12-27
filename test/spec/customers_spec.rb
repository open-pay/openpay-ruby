require '../spec_helper'


describe Customers do


  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'

    @openpay=OpenPayApi.new(@merchant_id,@private_key)
    @customers=@openpay.create(:customers)

  end


  describe '.create' do

    it 'create a customer' do

      name='Juan'
      last_name='Perez'
      customer_hash= FactoryGirl.build(:customer, name: name, last_name: last_name)
      customer=@customers.create(customer_hash)
      expect(customer).to be_a(Hash)

      id=customer['id']
      p id
      saved_customer=@customers.get_customer(id)
      expect(saved_customer['name']).to match(name)
      expect(saved_customer['last_name']).to match(last_name)

    end


    it 'fails when passing incomplete information' do

      email='foo'
      customer_hash = FactoryGirl.build(:customer, email: email)

      customer=@customers.create(customer_hash)
      expect(@customers.errors?).to be_true
      expect(customer['description']).to match "'email' not a well-formed email address"


    end

  end


  describe '.delete' do


    it 'deletes an existing customer' do
      customer_hash = FactoryGirl.build(:customer, name: :delete_me)

      customer=@customers.create(customer_hash)
      id=customer['id']
      @customers.delete(id)
      expect { @customers.get(id) }.to raise_exception RestClient::ResourceNotFound
    end

  end


  describe '.get' do

    it 'get a customer' do
      name='get_test'
      customer_hash = FactoryGirl.build(:customer, name: name)

      customer=@customers.create(customer_hash)
      id=customer['id']
      expect( @customers.get(id)['name'] ).to match name
    end


  end


  describe '.get_customer' do

    it 'get a customer' do

      name='get_customer_test'
      customer_hash = FactoryGirl.build(:customer, name: name)

      customer=@customers.create(customer_hash)
      id=customer['id']
      expect(@customers.get_customer(id)['name']).to match name
    end

  end


  describe '.each' do
    it 'list all customers' do
      @customers.each do |customer|
        expect(customer['phone_number']).to match '0180012345'
      end
    end
  end



  describe '.update' do

    it 'updates an existing customer'    do
      name='customer_update_test'
      customer_hash = FactoryGirl.build(:customer, name: name)

      customer=@customers.create(customer_hash)
      id=customer['id']

      name='new_name'
      customer_hash = FactoryGirl.build(:customer, name: name)
      @customers.update(customer_hash,id)
      expect(@customers.get_customer(id)['name']).to match name
    end

  end



  describe '.create_card' do

    it 'creates  a card for an existing customer' do
      name='create_card_test'
      customer_hash = FactoryGirl.build(:customer, name: name)
      card_hash = FactoryGirl.build(:valid_card,holder_name:  'Juan')


      customer=@customers.create(customer_hash)
      @customers.create_card(customer['id'],card_hash)
      expect( @customers.all_cards(customer['id']).size ).to be 1


    end



  end


  describe '.all_cards' do

    it 'list all cards for a given customer'  do

      @customers.each do |customer|
          customer['phone_number']
      end

    end


  end


  describe '.each_card' do

    it 'list all cards for a given customer'  do
      pending
    end


  end





  describe '.get_bank_account'    do

     it 'get a bank account'  do
       pending
     end

  end


  describe '.create_bank_account'    do

    it 'creates a bank account'  do
      pending
    end


  end




  describe '.all' do

    it 'list all the customers' do
      expect(@customers.all.size).to be 5
    end


  end



  describe '.delete_all!' do



    it 'raise an exception when used on Production' do

      @openpayprod=OpenPayApi.new(@merchant_id,@private_key,true)
      cust=@openpayprod.create(:customers)
      expect { cust.delete_all }.to raise_error


    end

    it 'deletes all customer records' do
     @customers.delete_all
     expect(@customers.all.size).to eq  0
    end

  end



end










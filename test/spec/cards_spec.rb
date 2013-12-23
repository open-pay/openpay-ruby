require '../spec_helper'


describe Cards do


  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'

    @openpay=OpenPayApi.new(@merchant_id, @private_key)
    @cards=@openpay.create(:cards)
    @customers=@openpay.create(:customers)

  end

  after(:all) do
    @openpay.create(:customers).delete_all!

  end





  describe '.create' do

    it 'creates  merchant card' do

      card_hash = FactoryGirl.build(:valid_card)
      cards=@cards.create(card_hash)
      expect(cards).to be_a(Hash)

      id=cards['id']


      name='Vicente Olmos'

      card=@cards.get(id)
      expect(card['holder_name']).to match(name)
      expect(card['card_number']).to match('1111')


      @cards.delete(card['id'])


    end


    it 'creates a customer card' do

      card_hash = FactoryGirl.build(:valid_card, holder_name: 'Pepe')

      customers=@openpay.create(:customers)
      customer_hash = FactoryGirl.build(:customer)
      customer=customers.create(customer_hash)

      cards=@cards.create(card_hash, customer['id'])
      expect(cards).to be_a(Hash)

      id=cards['id']

      customer_cards=customers.all_cards(customer['id'])
      expect(customer_cards.size).to be 1
      expect(cards['holder_name']).to match 'Pepe'

      stored_card=@cards.get(id , customer['id'] )
      expect(stored_card['holder_name']).to match 'Pepe'
      expect(stored_card['id']).to match id




      @cards.delete(id , customer['id'] )


    end


    it 'fails when trying to create an existing card' do
      customers=@openpay.create(:customers)

      customer_hash = FactoryGirl.build(:customer, name: 'Juan', last_name: 'Perez')
      customer=customers.create(customer_hash)

      card_hash = FactoryGirl.build(:valid_card)
      @cards.create(card_hash)
      expect { @cards.create(card_hash) }.to raise_error(RestClient::Conflict)
    end



    it 'fails when using an expired card' do
      card_hash = FactoryGirl.build(:expired_card)
      expect { @cards.create(card_hash) }.to raise_error(RestClient::PaymentRequired)
    end


    it 'fails when using a stolen card' do
      card_json = FactoryGirl.build(:valid_card, card_number: '4000000000000119')
      expect { @cards.create(card_json) }.to raise_error(RestClient::PaymentRequired)

    end

  end


  describe '.each' do

    it 'list all existing merchant cards' do
      @cards.each do |card|
        expect(card['expiration_year']).to match '14'
      end
    end


  end


  describe '.delete' do

    it 'deletes any existing card' do

      @cards.each do |card|
        @cards.delete(card['id'])
      end





    end



    it 'fails to deletes a non existing card' do

      expect { @cards.delete('1111111')  }.to raise_exception(RestClient::ResourceNotFound)


    end



    it  'deletes a customer card' do



      customers=@openpay.create(:customers)
      customer_hash = FactoryGirl.build(:customer, name: 'Juan', last_name: 'Paez')
      customer=customers.create(customer_hash)

      card_hash = FactoryGirl.build(:valid_card)

      card=@cards.create(card_hash, customer['id'])
      expect(card['holder_name']).to match 'Vicente Olmos'


      @cards.delete(card['id'],customer['id'])

    end


    it 'fails to deletes a non existing  customer card' do

      expect { @cards.delete('1111111','1111')  }.to raise_exception(RestClient::ResourceNotFound)


    end


  end


  describe '.get' do


    it ' gets an existing  merchant card' do
      bank_name='DESCONOCIDO'
      card_hash = FactoryGirl.build(:valid_card)

      card=@cards.create(card_hash)
      id=card['id']

      #pass just a single parameter for getting merchant cards
      stored_card = @cards.get(id)
      bank=stored_card['bank_name']
      expect(bank).to match bank_name
      @cards.delete(id)

    end


    it 'fails when getting a non existing card' do

       expect { @cards.get('11111')  }.to  raise_exception(RestClient::ResourceNotFound)


    end



    it ' gets an existing  customer card' do

      bank_name='DESCONOCIDO'
      customer_hash = FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)

      card_hash = FactoryGirl.build(:valid_card)

      card=@cards.create(card_hash, customer['id'])
      id=card['id']

      #two parameters  for getting customer cards
      stored_cards = @cards.get( id , customer['id'])
      bank=stored_cards['bank_name']
      expect(bank).to match bank_name
      @cards.delete(id , customer['id'])

    end


    it 'fails when getting a non existing customer card' do

      expect { @cards.get('11111','1111')  }.to  raise_exception(RestClient::ResourceNotFound)

   end


  end



  describe '.all' do

    it 'list all merchant cards' do


      expect(@cards.all.size).to be   0

      card_hash = FactoryGirl.build(:valid_card)

      card=@cards.create(card_hash)
      id=card['id']

      expect(@cards.all.size).to be   1

      @cards.delete(id)

    end


    it 'list all customer cards' do


      customer_hash = FactoryGirl.build(:customer)
      customer=@customers.create(customer_hash)

      expect(@cards.all(customer['id']).size).to be   0


      card_hash = FactoryGirl.build(:valid_card)

      card=@cards.create(card_hash, customer['id'])
      id=card['id']


      expect(@cards.all(customer['id']).size).to be   1

      @cards.delete(id , customer['id'])

    end


    it 'list cards for a non exisiting  customer'   do

      begin
      expect(@cards.all('111111').size).to be   0
      rescue => e

        expect(e.http_status).to be 404
        expect(e.json_body.kind_of?(Hash))
      end


    end





  end



  describe '.list' do

  it 'list the merchant cards using a filter' do

     pending
    #creation[gte]=yyyy-mm-dd
    #creation[lte]=yyyy-mm-dd
    #offset=0&
    #limit=10
   # @cards.list('2000-01-01','2000-01-01',0,10)



  end


  it 'list the customer cards using a filter' do
     pending
  end




  end





  describe '.delete_all' do

    it 'raise an exception when used on Production' do

      @openpayprod=OpenPayApi.new(@merchant_id, @private_key, true)
      cust=@openpayprod.create(:customers)
      expect { cust.delete_all! }.to raise_error


    end

    it 'deletes all existing cards' do

      @cards.delete_all!


    end


  end


end
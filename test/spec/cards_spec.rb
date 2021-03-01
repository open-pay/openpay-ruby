require_relative '../spec_helper'


describe Cards do

  # %w(create delete get list each all fail).each do |meth|
  # end

  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'
    
    #LOG.level=Logger::DEBUG

    @openpay=OpenpayApi.new(@merchant_id, @private_key)
    @cards=@openpay.create(:cards)
    @customers=@openpay.create(:customers)

    @cards.delete_all

  end

  after(:all) do
    #each test should build and clean it's own mess.
  end

  it 'has all required methods' do
    %w(all each create get list delete).each do |meth|
        expect(@cards).to respond_to(meth)
    end
  end

  describe '.create' do

    it 'creates merchant card' do

      #creates merchant card
      card_hash = FactoryBot.build(:valid_card)
      cards=@cards.create(card_hash)
      expect(cards).to be_a(Hash)

      id=cards['id']
      name='Vicente Olmos'

      #perform check
      card=@cards.get(id)
      expect(card['holder_name']).to match(name)
      expect(card['card_number']).to match('1111')

      #cleanup
      @cards.delete(card['id'])

    end

    it 'creates a customer card' do

      #creates a customer
      card_hash = FactoryBot.build(:valid_card, holder_name: 'Pepe')
      customers=@openpay.create(:customers)
      customer_hash = FactoryBot.build(:customer)
      customer=customers.create(customer_hash)

      #creates a customer card
      cards=@cards.create(card_hash, customer['id'])
      expect(cards).to be_a(Hash)

      id=cards['id']

      #performs check
      customer_cards=customers.all_cards(customer['id'])
      expect(customer_cards.size).to be 1
      expect(cards['holder_name']).to match 'Pepe'

      stored_card=@cards.get(id, customer['id'])
      expect(stored_card['holder_name']).to match 'Pepe'
      expect(stored_card['id']).to match id

      #cleanup
      @cards.delete(id, customer['id'])
      @customers.delete(customer['id'])

    end

    it 'create an existing merchant card' do

      #creates merchant card
      card_hash = FactoryBot.build(:valid_card)
      
      card=@cards.create(card_hash)
      #cleanup
      @cards.delete(card['id'])
      
      card=@cards.create(card_hash)
      #cleanup
      @cards.delete(card['id'])

    end

    it 'trying to create an existing customer card' do

      #creates a customer
      card_hash = FactoryBot.build(:valid_card, holder_name: 'Pepe')
      customers=@openpay.create(:customers)
      customer_hash = FactoryBot.build(:customer)
      customer=customers.create(customer_hash)

      #creates a customer card
      card=@cards.create(card_hash, customer['id'])
      expect(card).to be_a(Hash)

      #cleanup
      @cards.delete(card['id'], customer['id'])
      @customers.delete(customer['id'])

    end

    it 'fails when using an expired card' do
      card_hash = FactoryBot.build(:expired_card)
      #check
      expect { @cards.create(card_hash) }.to raise_error(OpenpayTransactionException)
      #extended check
      begin
        @cards.create(card_hash)
      rescue OpenpayTransactionException => e
        expect(e.description).to match 'The card has expired'
        expect(e.error_code).to be 3002
      end

    end

    it 'fails when using a stolen card' do
      card_json = FactoryBot.build(:valid_card, card_number: '4000000000000119')
      expect { @cards.create(card_json) }.to raise_error(OpenpayTransactionException)
    end

  end

  describe '.each' do

    it 'iterates over all existing merchant cards' do
      @cards.each do |card|
        expect(card['expiration_year']).to match '20'
      end
    end

    it 'iterates over all existing customer cards' do

      #creates a customer
      card_hash = FactoryBot.build(:valid_card, holder_name: 'Pepe')
      customers=@openpay.create(:customers)
      customer_hash = FactoryBot.build(:customer)
      customer=customers.create(customer_hash)

      #creates a customer card
      card=@cards.create(card_hash, customer['id'])
      expect(card).to be_a(Hash)

      @cards.each(customer['id']) do |c|
        expect(c['expiration_year']).to match '25'
      end

      #cleanup
      @cards.delete(card['id'], customer['id'])
      @customers.delete(customer['id'])

    end

  end

  describe '.delete' do

    it 'deletes a merchant card' do

      #creates merchant card
      card_hash = FactoryBot.build(:valid_card)
      cards=@cards.create(card_hash)
      expect(cards).to be_a(Hash)

      id=cards['id']
      name='Vicente Olmos'

      #perform check
      card=@cards.delete(id)
      expect { @cards.get(id) }.to raise_exception(OpenpayTransactionException)

    end

    it 'fails to deletes a non existing card' do
      expect { @cards.delete('1111111') }.to raise_exception(OpenpayTransactionException)
    end

    it 'deletes a customer card' do

      #create customer
      customers=@openpay.create(:customers)
      customer_hash = FactoryBot.build(:customer, name: 'Juan', last_name: 'Paez')
      customer=customers.create(customer_hash)

      #create customer card
      card_hash = FactoryBot.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #delete card
      @cards.delete(card['id'], customer['id'])

      #perform check
      expect { @cards.get(card['id'], customer['id']) }.to raise_exception(OpenpayTransactionException)

    end

    it 'fails to deletes a non existing  customer card' do
      expect { @cards.delete('1111111', '1111') }.to raise_exception(OpenpayTransactionException)
    end

  end

  describe '.get' do

    it ' gets an existing  merchant card' do

      #create merchant card
      bank_name='Banamex'
      card_hash = FactoryBot.build(:valid_card)

      card=@cards.create(card_hash)
      id=card['id']

      #pass just a single parameter for getting merchant cards
      stored_card = @cards.get(id)
      bank=stored_card['bank_name']
      expect(bank).to match bank_name

      #cleanup
      @cards.delete(id)

    end

    it 'fails when getting a non existing card' do
      expect { @cards.get('11111') }.to raise_exception(OpenpayTransactionException)
    end

    it ' gets an existing customer card' do

      #create customer
      customer_hash = FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #creates card
      bank_name='Banamex'
      card_hash = FactoryBot.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])
      id=card['id']

      #two parameters  for getting customer cards
      stored_cards = @cards.get(id, customer['id'])
      bank=stored_cards['bank_name']

      #perform check
      expect(bank).to match bank_name

      #cleanup
      @cards.delete(id, customer['id'])

    end

    it 'fails when getting a non existing customer card' do
      expect { @cards.get('11111', '1111') }.to raise_exception(OpenpayTransactionException)
    end

  end

  describe '.all' do

    it 'all merchant cards' do

      #check initial state
      expect(@cards.all.size).to be 0

      #create merchant card
      card_hash = FactoryBot.build(:valid_card)
      card=@cards.create(card_hash)
      id=card['id']

      #perform check
      expect(@cards.all.size).to be 1

      #cleanup
      @cards.delete(id)

    end

    it 'all customer cards' do

      #create customer
      customer_hash = FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #check initial state
      expect(@cards.all(customer['id']).size).to be 0

      #create customer card
      card_hash = FactoryBot.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])
      id=card['id']

      #perform check
      expect(@cards.all(customer['id']).size).to be 1

      #cleanup
      @cards.delete(id, customer['id'])

    end

    it 'cards for a non existing  customer' do
      expect { @cards.all('111111') }.to raise_exception OpenpayTransactionException
    end

  end

  describe '.list' do

    it 'list the merchant cards using a filter' do

      #create merchant card
      card_hash = FactoryBot.build(:valid_card)
      card1 = @cards.create(card_hash)

      card_hash = FactoryBot.build(:valid_card2)
      card2 = @cards.create(card_hash)

      search_params = OpenpayUtils::SearchParams.new
      search_params.limit = 1
      expect(@cards.list(search_params).size).to eq 1
      @cards.delete_all
    end

    it 'list the customer cards using a filter' do

      #create customer
      customer_hash = FactoryBot.build(:customer)
      customer = @customers.create(customer_hash)

      #creates card
      bank_name ='Banamex'
      card_hash = FactoryBot.build(:valid_card)
      card = @cards.create(card_hash, customer['id'])
      id = card['id']

      #creates card 2
      bank_name = 'Bancomer'
      card_hash = FactoryBot.build(:valid_card2)
      card = @cards.create(card_hash, customer['id'])
      id = card['id']

      search_params = OpenpayUtils::SearchParams.new
      search_params.limit = 1

      expect(@cards.all(customer['id']).size).to eq 2
      expect(@cards.list(search_params , customer['id']).size).to eq 1

      @cards.delete_all(customer['id'])

    end

    it 'list the merchant cards using a filter creation and amount' do
      #create merchant card
      card_hash = FactoryBot.build(:valid_card)
      card1 = @cards.create(card_hash)
      card_hash = FactoryBot.build(:valid_card2)
      card2 = @cards.create(card_hash)
      search_params = OpenpayUtils::SearchParams.new
      search_params.limit = 1
      creation_date = "2013-11-01"
      search_params.creation_gte = creation_date
      expect(@cards.list(search_params).size).to eq 1
      @cards.delete_all
    end
  end


  describe '.delete_all' do

    it 'raise an exception when used on Production' do

      openpayprod=OpenpayApi.new(@merchant_id, @private_key, true)
      cust=openpayprod.create(:customers)
      expect { cust.delete_all }.to raise_error

    end

    it 'deletes all existing  merchant cards' do

      #create merchant card
      card_hash = FactoryBot.build(:valid_card)
      @cards.create(card_hash)

      #using json just for fun ...and test
      card2_json = FactoryBot.build(:valid_card2).to_json
      @cards.create(card2_json)

      #perform check
      expect(@cards.all.size).to be 2

      #cleanup
      @cards.delete_all

      #perform check
      expect(@cards.all.size).to be 0

    end

    it 'deletes all existing cards for a given customer' do

      #creates customer
      customer_hash = FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #check initial state
      expect(@cards.all(customer['id']).size).to be 0

      #create card
      card_hash = FactoryBot.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #perform check
      expect(@cards.all(customer['id']).size).to be 1

      #cleanup
      @cards.delete_all(customer['id'])

      #check
      expect(@cards.all(customer['id']).size).to be 0

    end

  end

end

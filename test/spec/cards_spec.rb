require '../spec_helper'


describe Cards do


  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'

    @openpay=OpenPayApi.new(@merchant_id,@private_key)
    @cards=@openpay.create(:cards)

  end






  describe '.hash2json' do


    it 'converts a ruby hash into a json string' do
      card_hash = FactoryGirl.build(:valid_card,holder_name:  'Juan')
      json=@cards.hash2json(card_hash)
      expect(json).to have_json_path('holder_name')
      expect(json).to have_json_path('expiration_year')
      expect(json).to have_json_path('bank_code')

    end



  end



  describe '.json2hash' do


    it 'converts json into a ruby hash' do
      card_hash = FactoryGirl.build(:valid_card,holder_name:  'Pepe')
      json=@cards.hash2json(card_hash)
      jash=@cards.json2hash(json)
      expect(jash).to be_a Hash
      expect(jash['holder_name']).to match 'Pepe'


    end

  end





  describe '.add' do

      it 'adds a card to merchant' do

        card_hash = FactoryGirl.build(:valid_card)
        cards=@cards.add_card(card_hash)
        expect(cards).to be_a(Hash)

        id=cards['id']


        name='Rodrigo Bermejo'

        card=@cards.get_card(id)
        expect(card['holder_name']).to match(name)
        expect(card['card_number']).to match('1111')

      end



      it 'adds a card to customer' do

        card_hash = FactoryGirl.build(:valid_card)

        customers=@openpay.create(:customers)
        customer_hash = FactoryGirl.build(:customer, name: 'Juan', last_name: 'Perez')
        customer=customers.post(customer_hash)
        id=customer['id']
        card=@cards.add_card(card_hash,id)







      end


     it 'fails when trying to create an existing card' do
       card_json = FactoryGirl.build(:valid_card)
       expect { @cards.post(card_json) }.to  raise_error(RestClient::Conflict)
     end

    it 'fails when using an expired card' do
      card_json = FactoryGirl.build(:expired_card)
     expect { @cards.post(card_json) }.to raise_error( RestClient::PaymentRequired )
    end


    it 'fails when using a stolen card' do
      card_json = FactoryGirl.build(:valid_card, card_number: '4000000000000119')
      expect { @cards.post(card_json) }.to raise_error( RestClient::PaymentRequired )

    end

  end



  describe '.each' do

  it 'list all existing cards' do
    @cards.each do |card|
      p card
    end
   end


  end



  describe '.delete' do

    it 'deletes an existing card' do

     @cards.each do |card|
         @cards.delete(card['id'])
      end

    end


  end










  describe '.get_card' do

    it ' gets an existing card'  do
      bank_name='DESCONOCIDO'
      card_json = FactoryGirl.build(:valid_card)

      card=@cards.post(card_json)
      id=card['id']
      expect(@cards.get_card(id)['bank_name']).to match bank_name

    end

  end


 describe '.all' do

   it 'list all the customers' do
     expect(@cards.all.size).to be 1
   end

 end




  describe  '.delete_all' do

    it 'raise an exception when used on Production' do

      @openpayprod=OpenPayApi.new(@merchant_id,@private_key,true)
      cust=@openpayprod.create(:customers)
      expect { cust.delete_all! }.to raise_error


    end

    it 'deletes all existing cards' do

      @cards.delete_all!


    end




  end








end
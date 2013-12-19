require 'rspec'


describe 'OpenPayResource' do




  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'

    @openpay=OpenPayApi.new(@merchant_id,@private_key)

  end


  describe '.hash2json' do

    it 'should do something' do

      #To change this template use File | Settings | File Templates.
      true.should == false
    end
  end


  describe '.json2hash' do

    it 'should do something' do




      true.should == false
    end
  end


end
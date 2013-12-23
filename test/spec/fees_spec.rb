
require 'rspec'

describe Fees do



  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'

    @openpay=OpenPayApi.new(@merchant_id,@private_key)
    @customers=@openpay.create(:customers)

  end

  it 'should do something' do
    #To change this template use File | Settings | File Templates.
    expect(false).to be true
  end
end
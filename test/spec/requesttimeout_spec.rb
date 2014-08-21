require_relative '../spec_helper'


describe 'Request timeout exception' do

  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'

    @openpay=OpenpayApi.new(@merchant_id, @private_key, false, 0)
    @charges=@openpay.create(:charges)

  end

  it 'raise an OpenpayConnectionException when the operation timeouts' do
    expect{@charges.all}.to raise_error(OpenpayConnectionException)
  end

end

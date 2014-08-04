require_relative '../spec_helper'


describe Charges do

  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'

    @openpay=OpenpayApi.new(@merchant_id, @private_key, false, 5)
    @charges=@openpay.create(:charges)

  end

  describe '.all' do

    it 'get all charges' do

      @charges.all

    end

  end

end

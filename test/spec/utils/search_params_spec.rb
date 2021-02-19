require_relative '../../spec_helper'
include OpenpayUtils

describe OpenpayUtils do

  describe SearchParams do

    subject(:search_params) { SearchParams.new }

    describe 'setters and getters' do

      it 'sets and gets a given value' do
        val = "val"
        search_params.val = val
        expect(search_params.val).to eq(val)
      end

      it 'sets and gets a non existing attribute' do
        expect(search_params.val).to eq(nil)
      end
    end

    describe '.to_s' do
      it 'generates the filter string based on the attributes' do
        creation_date = "2013-11-01"
        search_params.creation_gte = creation_date
        limit = 2
        search_params.limit = limit
        amount = 100
        search_params.amount_lte = amount
        expect(search_params.to_s).to eq("?creation%5Bgte%5D=2013-11-01&limit=2&amount%5Blte%5D=100")
      end
    end
  end
end


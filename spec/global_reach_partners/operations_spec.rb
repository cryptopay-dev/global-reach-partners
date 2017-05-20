require 'spec_helper'

RSpec.describe GlobalReachPartners::Operations do
  subject { GlobalReachPartners }

  describe '.get_currencies' do
    it 'returns array of currencies', vcr: { cassette_name: 'operations/get_currencies' } do
      expect(subject.get_currencies.first).to be_kind_of(GlobalReachPartners::Currency)
    end
  end
end

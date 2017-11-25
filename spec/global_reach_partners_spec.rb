require 'spec_helper'

RSpec.describe GlobalReachPartners do
  subject(:grp) { described_class }

  describe '.closest_workday' do
    it 'returns GRP workday' do
      aggregate_failures do
        # 01/05/2017 - Monday
        expect(grp.closest_workday(Date.parse('01/05/2017'))).to eq Date.parse('02/05/2017')
        expect(grp.closest_workday(Date.parse('02/05/2017'))).to eq Date.parse('03/05/2017')
        expect(grp.closest_workday(Date.parse('03/05/2017'))).to eq Date.parse('04/05/2017')
        expect(grp.closest_workday(Date.parse('04/05/2017'))).to eq Date.parse('05/05/2017')
        expect(grp.closest_workday(Date.parse('05/05/2017'))).to eq Date.parse('08/05/2017')
        expect(grp.closest_workday(Date.parse('06/05/2017'))).to eq Date.parse('08/05/2017')
        expect(grp.closest_workday(Date.parse('07/05/2017'))).to eq Date.parse('08/05/2017')
        expect(grp.closest_workday(Date.parse('08/05/2017'))).to eq Date.parse('09/05/2017')
      end
    end
  end
end

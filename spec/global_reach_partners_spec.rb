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

    it 'skips holidays' do
      aggregate_failures do
        # 20171225    Mon    Christmas
        # 20171226    Tue    Boxing Day
        expect(grp.closest_workday(Date.parse('21/12/2017'))).to eq Date.parse('22/12/2017')
        expect(grp.closest_workday(Date.parse('22/12/2017'))).to eq Date.parse('27/12/2017')

        # 20180330    Fri    Good Friday
        # 20180402    Mon    Easter Monday
        expect(grp.closest_workday(Date.parse('28/03/2018'))).to eq Date.parse('29/03/2018')
        expect(grp.closest_workday(Date.parse('29/03/2018'))).to eq Date.parse('03/04/2018')
      end
    end
  end
end

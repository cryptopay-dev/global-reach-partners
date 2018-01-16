require 'spec_helper'

RSpec.describe GlobalReachPartners do
  subject(:grp) { described_class }

  describe '.closest_workday' do
    it 'returns GRP workday' do
      aggregate_failures do
        # 01/05/2017 - Monday
        expect(grp.closest_workday(date: date('01/05/2017'))).to eq date('02/05/2017')
        expect(grp.closest_workday(date: date('02/05/2017'))).to eq date('03/05/2017')
        expect(grp.closest_workday(date: date('03/05/2017'))).to eq date('04/05/2017')
        expect(grp.closest_workday(date: date('04/05/2017'))).to eq date('05/05/2017')
        expect(grp.closest_workday(date: date('05/05/2017'))).to eq date('08/05/2017')
        expect(grp.closest_workday(date: date('06/05/2017'))).to eq date('08/05/2017')
        expect(grp.closest_workday(date: date('07/05/2017'))).to eq date('08/05/2017')
        expect(grp.closest_workday(date: date('08/05/2017'))).to eq date('09/05/2017')
      end
    end

    it 'skips holidays' do
      aggregate_failures do
        # 20171225    GBP Mon    Christmas
        # 20171226    GBP Tue    Boxing Day
        expect(grp.closest_workday(date: date('21/12/2017'), currencies: %w[GBP])).to eq date('22/12/2017')
        expect(grp.closest_workday(date: date('22/12/2017'), currencies: %w[GBP])).to eq date('27/12/2017')

        # 20180330    GBP Fri    Good Friday
        # 20180402    GBP Mon    Easter Monday
        expect(grp.closest_workday(date: date('28/03/2018'), currencies: %w[GBP])).to eq date('29/03/2018')
        expect(grp.closest_workday(date: date('29/03/2018'), currencies: %w[GBP])).to eq date('03/04/2018')

        # 20180115    USD Fri    Martin Luther King Jr. Day
        expect(grp.closest_workday(date: date('12/01/2018'), currencies: %w[GBP])).to eq date('15/01/2018')
        expect(grp.closest_workday(date: date('12/01/2018'), currencies: %w[USD])).to eq date('16/01/2018')
        expect(grp.closest_workday(date: date('12/01/2018'), currencies: %w[GBP USD])).to eq date('16/01/2018')
      end
    end

    it 'does not fail on unknown currencies' do
      expect(grp.closest_workday(date: date('15/01/2018'), currencies: %w[BTC])).to eq date('16/01/2018')
    end

    def date(str)
      Date.parse(str)
    end
  end
end

require 'csv'

module GlobalReachPartners
  module Calendar
    extend self

    HOLIDAYS = CSV.read(Pathname(__FILE__).join('../../../holidays.csv'), col_sep: ';', headers: :first_row)
      .group_by { |r| r['Curr'] }
      .map { |currency, rows| [currency, rows.map { |r| Date.parse(r['HolidayDate']) }] }.to_h

    def closest_workday(date, currencies)
      date += 1.day
      date += 1.day while skip?(date, currencies)
      date
    end

    private

    def skip?(date, currencies)
      date.saturday? || date.sunday? || holiday?(date, currencies)
    end

    def holiday?(date, currencies)
      currencies.any? do |currency|
        HOLIDAYS[currency] && HOLIDAYS[currency].include?(date)
      end
    end
  end
end

module GlobalReachPartners
  module Calendar
    extend self

    HOLIDAYS = Pathname(__FILE__)
      .join('../../../holidays.txt')
      .each_line.map { |line| Date.parse(line.split.first) }

    def closest_workday(date)
      date += 1.day
      date += 1.day while skip?(date)
      date
    end

    private

    def skip?(date)
      date.saturday? || date.sunday? || HOLIDAYS.include?(date)
    end
  end
end

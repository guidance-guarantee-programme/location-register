class Slot
  Instance = Struct.new(:date, :start, :end)

  GRACE_PERIODS = {
    3 => :monday,
    4 => :tuesday,
    5 => :wednesday,
    6 => :thursday,
    0 => :thursday
  }.freeze

  class << self
    def all(cut_off_from = nil)
      slot_dates(cut_off_from).map do |date|
        [
          Instance.new(date.iso8601, '0900', '1300'),
          Instance.new(date.iso8601, '1300', '1700')
        ]
      end.flatten
    end

    private

    def slot_dates(cut_off_from)
      booking_window_end = 6.weeks.from_now

      (grace_period..booking_window_end).reject do |date|
        date.saturday? || date.sunday? || cut_off_from && date >= cut_off_from || bank_holiday?(date)
      end
    end

    def bank_holiday?(date)
      BANK_HOLIDAYS.include?(date)
    end

    def grace_period
      today = Time.zone.today

      if today.monday? || today.tuesday?
        today.advance(days: 3)
      else
        today.next_week(GRACE_PERIODS[today.wday])
      end
    end
  end
end

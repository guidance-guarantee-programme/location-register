Slot = Struct.new(:date, :start, :end) do
  GRACE_PERIODS = {
    3 => :monday,
    4 => :tuesday,
    5 => :wednesday,
    6 => :thursday,
    0 => :thursday
  }.freeze

  def self.all
    slot_dates.map do |date|
      [
        new(date.iso8601, '0900', '1300'),
        new(date.iso8601, '1300', '1700')
      ]
    end.flatten
  end

  def self.slot_dates
    booking_window_end = 6.weeks.from_now

    (grace_period..booking_window_end).reject do |date|
      date.saturday? || date.sunday?
    end
  end

  def self.grace_period
    today = Time.zone.today

    if today.monday? || today.tuesday?
      today.advance(days: 3)
    else
      today.next_week(GRACE_PERIODS[today.wday])
    end
  end
end

Slot = Struct.new(:date, :start, :end) do
  def self.all
    slot_dates.map do |date|
      [
        new(date.iso8601, '0900', '1300'),
        new(date.iso8601, '1300', '1700')
      ]
    end.flatten
  end

  def self.slot_dates
    grace_period = Time.zone.today + 2.days
    booking_window_end = 6.weeks.from_now

    (grace_period..booking_window_end).reject do |date|
      date.saturday? || date.sunday?
    end
  end
end

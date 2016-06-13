require 'rails_helper'

RSpec.describe Slot do
  subject do
    travel_to '2016-06-07 10:00:00' do
      Slot.all
    end
  end

  it 'returns slots for morning and afternoon' do
    expect(subject.first).to have_attributes(
      date: '2016-06-09',
      start: '0900',
      end: '1300'
    )

    expect(subject.second).to have_attributes(
      date: '2016-06-09',
      start: '1300',
      end: '1700'
    )
  end

  it 'returns slots two days from now' do
    expect(subject.first).to have_attributes(date: '2016-06-09')
  end

  it 'ignores weekends' do
    expect(
      subject
        .map { |slot| Date.parse(slot.date) }
        .none? { |d| d.saturday? || d.sunday? }
    ).to be_truthy
  end
end

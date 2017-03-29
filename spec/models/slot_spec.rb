require 'rails_helper'

RSpec.describe Slot do
  subject do
    travel_to(date) { described_class.all }
  end

  context 'on a bank holiday' do
    let(:date) { BANK_HOLIDAYS.first }

    it 'the first slot is the following Wednesday' do
      expect(subject.first).to have_attributes(date: '2017-04-19')
    end
  end

  context 'on Sunday' do
    let(:date) { '2016-06-05 10:00:00' }

    it 'the first slot is the following Thursday' do
      expect(subject.first).to have_attributes(date: '2016-06-09')
    end
  end

  context 'on Friday' do
    let(:date) { '2016-06-10 10:00:00' }

    it 'the first slot is the following Wednesday' do
      expect(subject.first).to have_attributes(date: '2016-06-15')
    end
  end

  context 'on Monday' do
    let(:date) { '2016-06-06 10:00:00' }

    it 'returns slots for morning and afternoon' do
      expect(subject.first).to have_attributes(
        start: '0900',
        end: '1300'
      )

      expect(subject.second).to have_attributes(
        start: '1300',
        end: '1700'
      )
    end

    it 'the first slot is the same Thursday' do
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
end

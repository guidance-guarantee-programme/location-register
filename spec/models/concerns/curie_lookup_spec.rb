require 'rails_helper'

RSpec.describe CurieLookup do
  class TestCurieLookup
    attr_accessor :uid

    class << self
      def find_by(params)
        new(params[:uid])
      end

      def column_names
        %w(uid)
      end
    end

    def initialize(uid = SecureRandom.uuid)
      @uid = uid
    end
  end

  class TestCurieLookupWithState < TestCurieLookup
    class << self
      def column_names
        %w(uid state)
      end
    end
  end

  let(:model) do
    Class.new(ActiveRecord::Base) do
      self.table_name = :locations # this is to allow curie_lookup params to be specified within the test
      include CurieLookup
      curie_lookup :address
    end
  end

  context 'storing' do
    subject { model.new }

    context 'a object' do
      it 'convert to curie based on class name and uid' do
        subject.address = TestCurieLookup.new('12345')
        expect(subject.read_attribute(:address)).to eq('[test_curie_lookup:12345]')
      end
    end

    context 'a string' do
      it 'when valid curie - stores the value directly' do
        subject.address = '[test_curie_lookup:12345]'
        expect(subject.read_attribute(:address)).to eq('[test_curie_lookup:12345]')
      end

      it 'when invalid curie - raises an error' do
        expect { subject.address = '12345' }.to raise_error(CurieLookup::InvalidCurie)
      end
    end

    context 'nil' do
      it 'as nil' do
        subject.address = TestCurieLookup.new('12345')
        subject.address = nil
        expect(subject.read_attribute(:address)).to be_nil
      end
    end
  end

  # expect to add an API lookup option to duplicate this functionality at some stage in the future
  describe '#CurieLokkup::DbRecord serializer' do
    context 'retrieving' do
      context 'from a valid curie' do
        subject { model.new.tap { |i| i.send(:write_attribute, :address, '[test_curie_lookup:54321]') } }

        it 'returns and object of the defined type' do
          expect(subject.address).to be_a(TestCurieLookup)
        end

        it 'looks the object up by uid' do
          expect(TestCurieLookup).to receive(:find_by).with(uid: '54321').and_call_original
          subject.address
        end

        context 'when the mapped class responds to state' do
          subject { model.new.tap { |i| i.send(:write_attribute, :address, '[test_curie_lookup_with_state:54321]') } }

          it 'looks the object up by uid and state == current' do
            expect(TestCurieLookupWithState).to receive(:find_by).with(uid: '54321', state: 'current').and_call_original
            subject.address
          end
        end

        context 'caching' do
          it 'on object lookup object to avoid duplicate requests' do
            expect(TestCurieLookup).to receive(:find_by).with(uid: '54321').and_call_original.once
            subject.address
            subject.address
          end

          it 'on object storage to avoid unnecessary lookups' do
            subject.address = TestCurieLookup.new
            expect(TestCurieLookup).not_to receive(:find_by)
            subject.address
          end

          it 'can no cache string storage so no cahcing here' do
            subject.address = '[test_curie_lookup:1234]'
            expect(TestCurieLookup).to receive(:find_by).and_call_original.once
            subject.address
          end
        end
      end

      context 'from nil' do
        subject { model.new }

        it 'returns nil' do
          expect(subject.address).to be_nil
        end
      end

      context 'from an invalid value' do
        subject { model.new.tap { |i| i.send(:write_attribute, :address, '4321') } }

        it 'raises an error' do
          expect { subject.address }.to raise_error(CurieLookup::InvalidCurie)
        end
      end
    end
  end
end

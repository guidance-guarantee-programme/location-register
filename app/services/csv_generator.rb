# frozen_string_literal: true
require 'csv'

class CsvGenerator
  def initialize(record_or_records)
    @records = Array(record_or_records)
  end

  def call
    CSV.generate do |output|
      output << attributes

      @records.each { |record| output << row(record) }
    end
  end
  alias csv call

  def attributes
    raise NotImplementedError
  end

  private

  def row(record)
    record
      .attributes
      .slice(*attributes)
      .map { |key, value| format(key, value) }
  end

  def format(key, value)
    formatter = "#{key}_formatter"

    respond_to?(formatter) ? public_send(formatter, value) : value
  end
end

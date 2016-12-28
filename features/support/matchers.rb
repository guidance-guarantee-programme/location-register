require 'rspec/expectations'

RSpec::Matchers.define :equal_edits do |expected_array|
  match do |actual_array|
    RSpecEditMatcher.match(actual_array, expected_array, 'equal')
  end

  failure_message do |actual_array|
    RSpecEditMatcher.failure_message(actual_array, expected_array, 'equal')
  end
end

RSpec::Matchers.define :match_edits do |expected_array|
  match do |actual_array|
    RSpecEditMatcher.match(actual_array, expected_array, 'match')
  end

  failure_message do |actual_array|
    RSpecEditMatcher.failure_message(actual_array, expected_array, 'match')
  end
end

module RSpecEditMatcher
  class ExpectationMustBeHash < StandardError; end
  class UnknownMatchType < StandardError; end

  module_function

  def match(actual_array, expected_array, match_type)
    if actual_array.count == expected_array.count
      actual_array.zip(expected_array).all? { |actual, expected| match_edit(actual, expected, match_type) }
    elsif expected_array.count == 1
      actual_array.any? { |actual| match_edit(actual, expected_array.first, match_type) }
    end
  end

  def failure_message(actual_array, expected_array, match_type = 'equal')
    if actual_array.count != expected_array.count
      "expected #{expected_array.count} edits but received #{actual_array.count} edits"
    else
      different = actual_array.zip(expected_array).reject do |actual, expected|
        match_edit(actual, expected, match_type)
      end
      different.map { |actual, expected| "expected #{expected.inspect} to #{match_type} #{actual}" }.join("\n")
    end
  end

  def match_edit(actual, expected, match_type)
    expected.is_a?(Hash) || raise(ExpectationMustBeHash, "received #{expected.class} instead")

    expected.all? do |field, expected_value|
      case match_type
      when 'equal'
        actual.send(field) == expected_value
      when 'match'
        actual.send(field).include?(expected_value)
      else
        raise(UnknownMatchType, match_type)
      end
    end
  end
end

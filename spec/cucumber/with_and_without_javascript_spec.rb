# taken from https://github.com/cucumber/cucumber-ruby-core/blob/master/spec/cucumber/core/gherkin/parser_spec.rb

require 'rails_helper'

require 'cucumber/core'
require 'cucumber/core/gherkin/writer'
require Rails.root.join('features/support/with_and_without_javascript')

module Cucumber
  module Core
    module Ast
      class Tag
        def ==(other)
          name == other.name && location == other.location
        end
      end
    end

    module Gherkin
      RSpec.describe Parser do
        include Writer

        let(:visitor) { double }

        def feature
          result = nil
          receiver = double
          allow(receiver).to receive(:feature) { |feature| result = feature }
          Parser.new(receiver).document(source)
          result
        end

        context 'a Scenario with @with_and_without_javascript tag' do
          let(:source) do
            gherkin do
              feature do
                scenario 'JS and Non-JS feature', tags: '@with_and_without_javascript' do
                  step
                end
              end
            end
          end
          let(:visitor) { double }
          let(:expected) { Ast::Tag.new(Ast::Location.new('features/test.feature', 3), '@with_and_without_javascript') }
          let(:expected_no_js) { Ast::Tag.new(Ast::Location.new('features/test.feature', 3), '@no-javascript') }
          let(:expected_js) { Ast::Tag.new(Ast::Location.new('features/test.feature', 3), '@javascript') }

          before do
            allow(visitor).to receive(:feature).and_yield(visitor)
            allow(visitor).to receive(:scenario).and_yield(visitor)
            allow(visitor).to receive(:step).and_yield(visitor)
          end

          it 'Generates an @javascript and @no-javascript tagged scenario' do
            expect(visitor).to receive(:scenario) do |scenario|
              expect(scenario.tags).to eq([expected, expected_no_js])
            end.once
            expect(visitor).to receive(:scenario) do |scenario|
              expect(scenario.tags).to eq([expected, expected_js])
            end.once

            feature.describe_to(visitor)
          end

          context 'when RUN_JAVASCRIPT_TESTS_ONLY environment variable is set' do
            it 'Generates only a @javascript tagged scenario' do
              allow(ENV).to receive(:[]).with('RUN_JAVASCRIPT_TESTS_ONLY').and_return('true')

              expect(visitor).to receive(:scenario) do |scenario|
                expect(scenario.tags).to eq([expected, expected_js])
              end.once

              feature.describe_to(visitor)
            end
          end
        end
      end
    end
  end
end
